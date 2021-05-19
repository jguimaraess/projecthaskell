{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql


-- O ideal eh ter apenas chamadas a templates.
-- css_bootstrap_css => css/bootstrap.css
getCadastrarR :: Handler Html
getCadastrarR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        setTitle "Cadastrar Cliente"
        -- dinamico
        --corpo html
        $(whamletFile "templates/scripts.hamlet")
        $(whamletFile "templates/navbar.hamlet")
        $(whamletFile "templates/login.hamlet")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")
        --javascript estático
        addScript $ (StaticR js_scripts_js) 

getEntrarR :: Handler Html
getEntrarR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        setTitle "Login"
        -- dinamico
        --corpo html
        $(whamletFile "templates/scripts.hamlet")
        $(whamletFile "templates/navbar.hamlet")
        $(whamletFile "templates/login.hamlet")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")
        --javascript estático
        addScript $ (StaticR js_scripts_js) 

