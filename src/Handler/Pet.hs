{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Pet where

import Import
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql


-- O ideal eh ter apenas chamadas a templates.
-- css_bootstrap_css => css/bootstrap.css
getPetR :: Handler Html
getPetR = do
    defaultLayout $ do
        addScriptRemote "https://code.jquery.com/jquery-3.6.0.js"
        addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"
        addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/animejs/3.2.1/anime.min.js"
        addStylesheetRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css"

        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        setTitle "Cadastrar Pet"
        -- dinamico
        --corpo html
        $(whamletFile "templates/navbar.hamlet")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")
        --javascript estático
        addScript $ (StaticR js_scripts_js) 

