module HtmlToElm exposing (rule)

{-|

@docs rule

-}

import AssocList as Dict exposing (Dict)
import AssocSet as Set exposing (Set)
import Config
import Elm.Pretty
import Elm.Project
import Elm.Syntax.Declaration as Declaration exposing (Declaration)
import Elm.Syntax.Exposing as Exposing
import Elm.Syntax.Expression as Expression exposing (Expression, Function)
import Elm.Syntax.Import exposing (Import)
import Elm.Syntax.Infix as Infix exposing (InfixDirection(..))
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node as Node exposing (Node(..))
import Elm.Syntax.Pattern exposing (Pattern(..))
import Elm.Syntax.Range exposing (Range)
import Elm.Syntax.Signature exposing (Signature)
import Elm.Syntax.Type
import Elm.Syntax.TypeAnnotation as TypeAnnotation exposing (TypeAnnotation)
import HtmlToTailwind
import Pretty
import QualifiedType exposing (QualifiedType, TypeAnnotation_(..), TypeOrTypeAlias(..), Type_)
import Review.Fix
import Review.ModuleNameLookupTable as ModuleNameLookupTable exposing (ModuleNameLookupTable)
import Review.Rule as Rule exposing (Error, ModuleKey, Rule)


{-| Reports... REPLACEME

    config =
        [ HtmlToElm.rule
        ]


## Fail

    a =
        "REPLACEME example to replace"


## Success

    a =
        "REPLACEME example to replace"


## When (not) to enable this rule

This rule is useful when REPLACEME.
This rule is not useful when REPLACEME.


## Try it out

You can try this rule out by running the following command:

```bash
elm-review --template dillonkearns/elm-review-html-to-elm/example --rules HtmlToElm
```

-}
rule : Rule
rule =
    Rule.newProjectRuleSchema "HtmlToElm" initialProjectContext
        |> Rule.withContextFromImportedModules
        |> Rule.withModuleVisitor moduleVisitor
        |> Rule.withModuleContextUsingContextCreator
            { fromProjectToModule = Rule.initContextCreator fromProjectToModule |> Rule.withModuleNameLookupTable |> Rule.withMetadata
            , fromModuleToProject = Rule.initContextCreator fromModuleToProject |> Rule.withModuleKey |> Rule.withMetadata
            , foldProjectContexts = foldProjectContexts
            }
        |> Rule.withElmJsonProjectVisitor elmJsonVisitor
        |> Rule.withFinalProjectEvaluation finalProjectEvaluation
        |> Rule.fromProjectRuleSchema



-- MODULE VISITOR


importVisitor : Node Import -> ModuleContext -> ( List (Error {}), ModuleContext )
importVisitor importNode context =
    let
        importThing : Import
        importThing =
            Node.value importNode
    in
    case Node.value importNode |> .moduleName |> Node.value of
        modName ->
            let
                nameOrAlias : ModuleName
                nameOrAlias =
                    importThing.moduleAlias
                        |> Maybe.map Node.value
                        |> Maybe.withDefault modName

                exposingList : Config.Exposing
                exposingList =
                    importThing.exposingList
                        |> Maybe.map Node.value
                        |> (\exposingL ->
                                case exposingL of
                                    Just (Exposing.All _) ->
                                        Config.All

                                    Just (Exposing.Explicit exposed) ->
                                        exposed
                                            |> List.map Node.value
                                            |> List.filterMap
                                                (\exposedItem ->
                                                    case exposedItem of
                                                        Exposing.FunctionExpose name ->
                                                            Just name

                                                        _ ->
                                                            Nothing
                                                )
                                            |> Config.Some

                                    Nothing ->
                                        Config.None
                           )

                isTailwindImport : Bool
                isTailwindImport =
                    modName == [ "Tailwind", "Utilities" ] || modName == [ "Tailwind", "Breakpoints" ]

                setField : ( String, Config.Exposing ) -> Config.Config -> Config.Config
                setField value config =
                    case modName of
                        [ "Svg" ] ->
                            { config | svg = value }

                        [ "Svg", "Attributes" ] ->
                            { config | svgAttr = value }

                        [ "Html" ] ->
                            { config | html = value }

                        [ "Html", "Attributes" ] ->
                            { config | htmlAttr = value }

                        [ "Html", "Styled" ] ->
                            { config | html = value }

                        [ "Html", "Styled", "Attributes" ] ->
                            { config | htmlAttr = value }

                        [ "Svg", "Styled" ] ->
                            { config | svg = value }

                        [ "Svg", "Styled", "Attributes" ] ->
                            { config | svgAttr = value }

                        [ "Tailwind", "Utilities" ] ->
                            { config | tw = value }

                        [ "Tailwind", "Breakpoints" ] ->
                            { config | bp = value }

                        _ ->
                            config
            in
            ( []
            , context
                |> updateConfig (setField ( nameOrAlias |> String.join ".", exposingList ))
                |> updateConfig
                    (\config ->
                        if isTailwindImport then
                            { config | useTailwindModules = True }

                        else
                            config
                    )
            )


updateConfig : (Config.Config -> Config.Config) -> ModuleContext -> ModuleContext
updateConfig updateFn context =
    { context | config = updateFn context.config }


moduleVisitor : Rule.ModuleRuleSchema {} ModuleContext -> Rule.ModuleRuleSchema { hasAtLeastOneVisitor : () } ModuleContext
moduleVisitor schema =
    schema
        |> Rule.withDeclarationListVisitor declarationVisitor
        |> Rule.withImportVisitor importVisitor



-- CONTEXT


type alias ProjectContext =
    { types : List ( ModuleName, TypeOrTypeAlias )
    , codecs : List { moduleName : ModuleName, functionName : String, typeVar : QualifiedType }
    , todos : List ( ModuleName, Todo )
    , moduleKeys : Dict ModuleName ModuleKey
    }


type alias HtmlTodoData =
    { functionName : String
    , range : Range
    , parameters : List (Node Pattern)
    , signature : Signature
    , todoText : String
    , config : Config.Config
    }


type Todo
    = HtmlTodo HtmlTodoData


type alias ModuleContext =
    { lookupTable : ModuleNameLookupTable.ModuleNameLookupTable
    , types : List TypeOrTypeAlias
    , codecs : List { functionName : String, typeVar : QualifiedType }
    , todos : List Todo
    , currentModule : ModuleName
    , moduleLookupTable : ModuleNameLookupTable
    , config : Config.Config
    }


initialProjectContext : ProjectContext
initialProjectContext =
    { types = []
    , codecs = []
    , todos = []
    , moduleKeys = Dict.empty
    }


fromProjectToModule : ModuleNameLookupTable -> Rule.Metadata -> ProjectContext -> ModuleContext
fromProjectToModule lookupTable metadata projectContext =
    let
        moduleName : ModuleName
        moduleName =
            Rule.moduleNameFromMetadata metadata
    in
    { lookupTable = lookupTable
    , types = projectContext.types |> List.filter (Tuple.first >> (==) moduleName) |> List.map Tuple.second
    , codecs =
        List.map
            (\a -> { functionName = a.functionName, typeVar = a.typeVar })
            projectContext.codecs
    , todos =
        List.filterMap
            (\( moduleName_, todo ) ->
                if moduleName_ == moduleName then
                    Just todo

                else
                    Nothing
            )
            projectContext.todos
    , currentModule = moduleName
    , moduleLookupTable = lookupTable
    , config = Config.default
    }


fromModuleToProject : Rule.ModuleKey -> Rule.Metadata -> ModuleContext -> ProjectContext
fromModuleToProject moduleKey metadata moduleContext =
    let
        moduleName : ModuleName
        moduleName =
            Rule.moduleNameFromMetadata metadata
    in
    { types = List.map (Tuple.pair moduleName) moduleContext.types
    , codecs =
        List.map
            (\a -> { moduleName = moduleName, functionName = a.functionName, typeVar = a.typeVar })
            moduleContext.codecs
    , todos = List.map (\todo -> ( moduleName, todo )) moduleContext.todos
    , moduleKeys = Dict.singleton moduleName moduleKey
    }


foldProjectContexts : ProjectContext -> ProjectContext -> ProjectContext
foldProjectContexts newContext previousContext =
    { types = newContext.types ++ previousContext.types
    , codecs = newContext.codecs ++ previousContext.codecs
    , todos = newContext.todos ++ previousContext.todos
    , moduleKeys = Dict.union newContext.moduleKeys previousContext.moduleKeys
    }



-- ELM.JSON VISITOR


elmJsonVisitor : Maybe { elmJsonKey : Rule.ElmJsonKey, project : Elm.Project.Project } -> ProjectContext -> ( List nothing, ProjectContext )
elmJsonVisitor maybeElmJson projectContext =
    case maybeElmJson |> Maybe.map .project of
        Just (Elm.Project.Package _) ->
            ( [], projectContext )

        Just (Elm.Project.Application _) ->
            ( [], projectContext )

        Nothing ->
            ( [], projectContext )



-- DECLARATION VISITOR


convertTypeAnnotation : ModuleContext -> TypeAnnotation -> TypeAnnotation_
convertTypeAnnotation moduleContext typeAnnotation =
    case typeAnnotation of
        TypeAnnotation.GenericType string ->
            QualifiedType.GenericType_ string

        TypeAnnotation.Typed a nodes ->
            case QualifiedType.create moduleContext.moduleLookupTable moduleContext.currentModule a of
                Just qualified ->
                    QualifiedType.Typed_
                        qualified
                        (List.map (Node.value >> convertTypeAnnotation moduleContext) nodes)

                Nothing ->
                    QualifiedType.Unit_

        TypeAnnotation.Unit ->
            QualifiedType.Unit_

        TypeAnnotation.Tupled nodes ->
            QualifiedType.Tupled_ (List.map (Node.value >> convertTypeAnnotation moduleContext) nodes)

        TypeAnnotation.Record recordDefinition ->
            QualifiedType.Record_ (convertRecordDefinition moduleContext recordDefinition)

        TypeAnnotation.GenericRecord a (Node _ recordDefinition) ->
            QualifiedType.GenericRecord_
                (Node.value a)
                (convertRecordDefinition moduleContext recordDefinition)

        TypeAnnotation.FunctionTypeAnnotation (Node _ a) (Node _ b) ->
            QualifiedType.FunctionTypeAnnotation_
                (convertTypeAnnotation moduleContext a)
                (convertTypeAnnotation moduleContext b)


convertRecordDefinition : ModuleContext -> List (Node ( Node a, Node TypeAnnotation )) -> List ( a, TypeAnnotation_ )
convertRecordDefinition moduleContext recordDefinition =
    List.map
        (\(Node _ ( Node _ fieldName, Node _ fieldValue )) ->
            ( fieldName, convertTypeAnnotation moduleContext fieldValue )
        )
        recordDefinition


convertType : ModuleContext -> Elm.Syntax.Type.Type -> Type_
convertType moduleContext type_ =
    { name = Node.value type_.name
    , generics = List.map Node.value type_.generics
    , constructors =
        List.map
            (\(Node _ constructor) ->
                { name = Node.value constructor.name
                , arguments =
                    List.map
                        (Node.value >> convertTypeAnnotation moduleContext)
                        constructor.arguments
                }
            )
            type_.constructors
    }


declarationVisitor : List (Node Declaration) -> ModuleContext -> ( List a, ModuleContext )
declarationVisitor declarations context =
    let
        context2 : ModuleContext
        context2 =
            { context
                | types =
                    List.filterMap
                        (declarationVisitorGetTypes context)
                        declarations
                        ++ context.types
                , codecs =
                    List.filterMap
                        (\declaration ->
                            case declaration of
                                Node _ (Declaration.FunctionDeclaration function) ->
                                    declarationVisitorGetCodecs context function

                                _ ->
                                    Nothing
                        )
                        declarations
                        ++ context.codecs
            }
    in
    ( []
    , { context2
        | todos =
            List.filterMap
                (\declaration ->
                    case declaration of
                        Node range (Declaration.FunctionDeclaration function) ->
                            getCodecTodo context range function

                        _ ->
                            Nothing
                )
                declarations
                ++ context.todos
      }
    )


declarationVisitorGetCodecs : ModuleContext -> Function -> Maybe { functionName : String, typeVar : QualifiedType }
declarationVisitorGetCodecs context function =
    case ( function.signature, function.declaration ) of
        ( Just (Node _ signature), Node _ declaration ) ->
            case typeAnnotationReturnValue signature.typeAnnotation of
                Node _ (TypeAnnotation.Typed (Node _ ( [], "Codec" )) [ Node _ _, Node _ (TypeAnnotation.Typed codecType _) ]) ->
                    if hasDebugTodo declaration then
                        Nothing

                    else
                        case QualifiedType.create context.lookupTable context.currentModule codecType of
                            Just qualifiedType ->
                                { functionName = Node.value signature.name
                                , typeVar = qualifiedType
                                }
                                    |> Just

                            Nothing ->
                                Nothing

                _ ->
                    Nothing

        _ ->
            Nothing


declarationVisitorGetTypes : ModuleContext -> Node Declaration -> Maybe TypeOrTypeAlias
declarationVisitorGetTypes context node_ =
    case Node.value node_ of
        Declaration.CustomTypeDeclaration customType ->
            TypeValue (convertType context customType) |> Just

        Declaration.AliasDeclaration typeAlias ->
            case Node.value typeAlias.typeAnnotation of
                TypeAnnotation.Record record ->
                    TypeAliasValue
                        (Node.value typeAlias.name)
                        (convertRecordDefinition context record)
                        |> Just

                _ ->
                    Nothing

        _ ->
            Nothing


typeAnnotationReturnValue : Node TypeAnnotation -> Node TypeAnnotation
typeAnnotationReturnValue typeAnnotation =
    case typeAnnotation of
        Node _ (TypeAnnotation.FunctionTypeAnnotation _ node_) ->
            typeAnnotationReturnValue node_

        _ ->
            typeAnnotation


getCodecTodo : ModuleContext -> Range -> Function -> Maybe Todo
getCodecTodo context declarationRange function =
    let
        declaration : Expression.FunctionImplementation
        declaration =
            Node.value function.declaration

        newThing : { name : Node String, typeAnnotation : Node TypeAnnotation } -> Maybe Todo
        newThing signature =
            hasHtmlDebugTodo declaration
                |> Maybe.andThen
                    (\todoText ->
                        HtmlTodo
                            { functionName = Node.value signature.name
                            , range = declarationRange
                            , parameters = declaration.arguments
                            , signature = signature
                            , todoText = todoText
                            , config = context.config
                            }
                            |> Just
                    )
    in
    case function.signature of
        Just (Node _ signature) ->
            case typeAnnotationReturnValue signature.typeAnnotation of
                Node _ (TypeAnnotation.Typed (Node _ ( [ "Html" ], "Html" )) [ Node _ (TypeAnnotation.Typed _ _) ]) ->
                    newThing signature

                Node _ (TypeAnnotation.Typed (Node _ ( [], "Html" )) [ Node _ _ ]) ->
                    newThing signature

                _ ->
                    Nothing

        _ ->
            Nothing


hasDebugTodo : { a | expression : Node Expression } -> Bool
hasDebugTodo declaration =
    case declaration.expression of
        Node _ (Expression.Application ((Node _ (Expression.FunctionOrValue [ "Debug" ] "todo")) :: (Node _ (Expression.Literal _)) :: _)) ->
            True

        _ ->
            False


hasHtmlDebugTodo : { a | expression : Node Expression } -> Maybe String
hasHtmlDebugTodo declaration =
    case declaration.expression of
        Node _ (Expression.Application ((Node _ (Expression.FunctionOrValue [ "Debug" ] "todo")) :: (Node _ (Expression.Literal debugString)) :: _)) ->
            Just debugString

        _ ->
            Nothing


generateRecordCodec : ProjectContext -> Maybe String -> List ( String, TypeAnnotation_ ) -> Node Expression
generateRecordCodec projectContext typeAliasName recordFields =
    List.foldl
        (\( fieldName, typeAnnotation ) code ->
            code
                |> pipeRight
                    (application
                        [ functionOrValue [ "Serialize" ] "field"
                        , Expression.RecordAccessFunction fieldName |> node
                        , codecFromTypeAnnotation projectContext typeAnnotation
                        ]
                    )
        )
        (application
            [ functionOrValue [ "Serialize" ] "record"
            , case typeAliasName of
                Just typeAliasName_ ->
                    functionOrValue [] typeAliasName_

                Nothing ->
                    Expression.LambdaExpression
                        { args =
                            List.range 0 (List.length recordFields - 1)
                                |> List.map (varFromInt >> VarPattern >> node)
                        , expression =
                            List.indexedMap
                                (\index ( fieldName, _ ) ->
                                    ( node fieldName, functionOrValue [] (varFromInt index) ) |> node
                                )
                                recordFields
                                |> Expression.RecordExpr
                                |> node
                        }
                        |> node
                        |> parenthesis
            ]
        )
        recordFields
        |> pipeRight (application [ functionOrValue [ "Serialize" ] "finishRecord" ])


varFromInt : Int -> String
varFromInt =
    (+) (Char.toCode 'a')
        >> Char.fromCode
        >> String.fromChar


generateHtmlTodoDefinition : HtmlTodoData -> String
generateHtmlTodoDefinition htmlTodo =
    ({ documentation = Nothing
     , signature = node htmlTodo.signature |> Just
     , declaration =
        node
            { name = node htmlTodo.functionName
            , arguments = htmlTodo.parameters
            , expression = application [] -- hack for an empty function body since we're just generating a plain String
            }
     }
        |> writeDeclaration
    )
        ++ htmlToElm htmlTodo.config htmlTodo.todoText


htmlToElm : Config.Config -> String -> String
htmlToElm config htmlString =
    HtmlToTailwind.htmlToElmTailwindModules config htmlString


writeDeclaration : Function -> String
writeDeclaration =
    Elm.Pretty.prettyFun >> Pretty.pretty 100


codecFromTypeAnnotation : ProjectContext -> TypeAnnotation_ -> Node Expression
codecFromTypeAnnotation projectContext typeAnnotation =
    case typeAnnotation of
        Typed_ qualifiedType typeVariables ->
            let
                getCodecName : String -> Node Expression
                getCodecName text =
                    case text of
                        "Int" ->
                            functionOrValue [ "Serialize" ] "int"

                        "Float" ->
                            functionOrValue [ "Serialize" ] "float"

                        "String" ->
                            functionOrValue [ "Serialize" ] "string"

                        "Bool" ->
                            functionOrValue [ "Serialize" ] "bool"

                        "Maybe" ->
                            functionOrValue [ "Serialize" ] "maybe"

                        "Dict" ->
                            functionOrValue [ "Serialize" ] "dict"

                        "Set" ->
                            functionOrValue [ "Serialize" ] "set"

                        "Result" ->
                            functionOrValue [ "Serialize" ] "result"

                        "List" ->
                            functionOrValue [ "Serialize" ] "list"

                        "Array" ->
                            functionOrValue [ "Serialize" ] "array"

                        _ ->
                            functionOrValue [] (uncapitalize text ++ "Codec")

                applied : Node Expression
                applied =
                    (case find (.typeVar >> (==) qualifiedType) projectContext.codecs of
                        Just codec ->
                            functionOrValue codec.moduleName codec.functionName

                        Nothing ->
                            getCodecName (QualifiedType.name qualifiedType)
                    )
                        :: List.map (codecFromTypeAnnotation projectContext) typeVariables
                        |> application
            in
            if List.isEmpty typeVariables then
                applied

            else
                parenthesis applied

        Unit_ ->
            functionOrValue [ "Serialize" ] "unit"

        Tupled_ [ first ] ->
            codecFromTypeAnnotation projectContext first

        Tupled_ [ first, second ] ->
            application
                [ functionOrValue [ "Serialize" ] "tuple"
                , codecFromTypeAnnotation projectContext first
                , codecFromTypeAnnotation projectContext second
                ]
                |> parenthesis

        Tupled_ [ first, second, third ] ->
            application
                [ functionOrValue [ "Serialize" ] "triple"
                , codecFromTypeAnnotation projectContext first
                , codecFromTypeAnnotation projectContext second
                , codecFromTypeAnnotation projectContext third
                ]
                |> parenthesis

        Tupled_ _ ->
            functionOrValue [ "Serialize" ] "unit"

        FunctionTypeAnnotation_ _ _ ->
            errorMessage "Functions can't be serialized"

        GenericType_ _ ->
            notSupportedErrorMessage

        Record_ fields ->
            generateRecordCodec projectContext Nothing fields |> parenthesis

        GenericRecord_ _ _ ->
            notSupportedErrorMessage


notSupportedErrorMessage : Node Expression
notSupportedErrorMessage =
    errorMessage "Can't handle this"


errorMessage : String -> Node Expression
errorMessage error =
    application
        [ functionOrValue [ "Debug" ] "todo"
        , Expression.Literal error |> node
        ]
        |> parenthesis


getTypesFromTypeAnnotation : ProjectContext -> ModuleName -> Set QualifiedType -> TypeAnnotation_ -> Set QualifiedType
getTypesFromTypeAnnotation projectContext typeModuleName collectedTypes typeAnnotation =
    case typeAnnotation of
        Typed_ qualifiedType typeParameters ->
            let
                collectedTypes_ : Set QualifiedType
                collectedTypes_ =
                    if QualifiedType.isPrimitiveType qualifiedType then
                        collectedTypes

                    else if Set.member qualifiedType collectedTypes then
                        collectedTypes

                    else
                        getTypesHelper
                            projectContext
                            qualifiedType
                            (Set.insert qualifiedType collectedTypes)
                            |> Set.union collectedTypes
            in
            List.foldl
                (\typeParameter collectedTypes__ ->
                    getTypesFromTypeAnnotation projectContext typeModuleName collectedTypes__ typeParameter
                        |> Set.union collectedTypes__
                )
                collectedTypes_
                typeParameters

        _ ->
            collectedTypes


getTypesHelper :
    ProjectContext
    -> QualifiedType
    -> Set QualifiedType
    -> Set QualifiedType
getTypesHelper projectContext typeDeclaration collectedTypes =
    case QualifiedType.getTypeData projectContext.types typeDeclaration of
        Just ( typeModuleName, TypeAliasValue _ fields ) ->
            List.foldl
                (\( _, typeAnnotation ) collectedTypes_ ->
                    getTypesFromTypeAnnotation projectContext typeModuleName collectedTypes_ typeAnnotation
                )
                collectedTypes
                fields

        Just ( typeModuleName, TypeValue customType ) ->
            List.foldl
                (\constructor collectedTypes_ ->
                    List.foldl
                        (\typeAnnotation collectedTypes__ ->
                            getTypesFromTypeAnnotation projectContext typeModuleName collectedTypes__ typeAnnotation
                        )
                        collectedTypes_
                        constructor.arguments
                )
                collectedTypes
                customType.constructors

        Nothing ->
            collectedTypes


finalProjectEvaluation : ProjectContext -> List (Error { useErrorForModule : () })
finalProjectEvaluation projectContext =
    let
        todoFixes : List (Error { useErrorForModule : () })
        todoFixes =
            projectContext.todos
                |> List.filterMap
                    (\( moduleName, todo ) ->
                        case todo of
                            HtmlTodo htmlTodo ->
                                case Dict.get moduleName projectContext.moduleKeys of
                                    Just moduleKey ->
                                        let
                                            fix : String
                                            fix =
                                                generateHtmlTodoDefinition htmlTodo
                                        in
                                        Rule.errorForModuleWithFix
                                            moduleKey
                                            { message = "Here's my attempt to complete this stub"
                                            , details = [ "" ]
                                            }
                                            htmlTodo.range
                                            (Review.Fix.replaceRangeBy htmlTodo.range fix
                                                :: List.filterMap
                                                    (\( moduleName_, fix_ ) ->
                                                        if moduleName_ == moduleName then
                                                            Just fix_

                                                        else
                                                            Nothing
                                                    )
                                                    []
                                            )
                                            |> Just

                                    _ ->
                                        Nothing
                    )
    in
    todoFixes


node : a -> Node a
node =
    Node Elm.Syntax.Range.emptyRange


application : List (Node Expression) -> Node Expression
application =
    Expression.Application >> node


functionOrValue : ModuleName -> String -> Node Expression
functionOrValue moduleName functionOrValueName =
    Expression.FunctionOrValue moduleName functionOrValueName |> node


pipeRight : Node Expression -> Node Expression -> Node Expression
pipeRight eRight eLeft =
    Expression.OperatorApplication "|>" Infix.Left eLeft eRight |> node


parenthesis : Node Expression -> Node Expression
parenthesis =
    Expression.ParenthesizedExpression >> node


{-| Find the first element that satisfies a predicate and return
Just that element. If none match, return Nothing.
find (\\num -> num > 5) [ 2, 4, 6, 8 ]
--> Just 6

Borrowed from elm-community/list-extra

-}
find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just first

            else
                find predicate rest


uncapitalize : String -> String
uncapitalize text =
    String.toLower (String.left 1 text) ++ String.dropLeft 1 text
