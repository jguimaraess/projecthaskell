{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql


-- O ideal eh ter apenas chamadas a templates.
-- css_bootstrap_css => css/bootstrap.css
getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        setTitle "Petshow! Seu pet bem cuidado" 
        --corpo html
        $(whamletFile "templates/scripts.hamlet")
        $(whamletFile "templates/navbar.hamlet")
        $(whamletFile "templates/header.hamlet")
        $(whamletFile "templates/portfolio.hamlet")
        $(whamletFile "templates/sobrenos.hamlet")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")

        --javascript estático
        addScript $ (StaticR js_scripts_js) 
