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
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getPage1R :: Handler Html
getPage1R = do
    defaultLayout $ do
        [whamlet|
            <h1>
                PAGINA 1
                
        |]

getPage2R :: Handler Html
getPage2R = do
    defaultLayout $ do
        [whamlet|
            <h1>
                PAGINA 2
        |]        
    
getPage3R :: Handler Html
getPage3R = do
    defaultLayout $ do
        [whamlet|
            <h1>
                PAGINA 3
        |]
    
-- O ideal eh ter apenas chamadas a templates.
-- css_bootstrap_css => css/bootstrap.css
getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        -- dinamico
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/home.hamlet")
