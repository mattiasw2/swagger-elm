module Generate exposing (main, generate)

import Html exposing (text)
import Html exposing (programWithFlags)
import Json.Decode as Decode exposing (decodeString)
import Swagger.Decode as Swagger exposing (decodeSwagger)
import Swagger.Flatten exposing (flatten)
import Generate.Swagger exposing (render)


main : Program String String x
main =
    programWithFlags
        { init = init
        , view = text << toOutput << generate
        , update = always << always ( "", Cmd.none )
        , subscriptions = always Sub.none
        }


init : String -> ( String, Cmd x )
init json =
    ( json, Cmd.none )


toOutput : Result String String -> String
toOutput result =
    case result of
        Err err ->
            Debug.log "error" err

        Ok str ->
            str


generate : String -> Result String String
generate json =
    decodeString decodeSwagger json
        |> Result.map (flatten >> render)
