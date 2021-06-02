{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
import Text.Lucius
import Text.Julius
import Handler.Auxiliar

formLogin :: Form (Usuario, Text)
formLogin = renderBootstrap $ (,)
        <$> (Usuario
        <$> areq emailField "Email: " Nothing
        <*> areq passwordField "Senha de Usuário: "  Nothing
        )
    <*> areq passwordField "Confirmação de Senha: " Nothing

getUsuarioR :: Handler Html
getUsuarioR = do
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do
        addStylesheetRemote "http://remote-bootstrap-path.css"
        addScriptRemote "https://code.jquery.com/jquery-3.6.0.js"
        addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js"
        addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/popper.js/2.9.2/umd/popper.min.js"
        addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/jQuery.mmenu/8.5.22/mmenu.js"
        addStylesheetRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"

        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        addStylesheet (StaticR css_profile_css)
        setTitle "Cadastro de Usuário"
        (formWidget widget msg UsuarioR "Cadastrar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")


postUsuarioR :: Handler Html
postUsuarioR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess (usuario@(Usuario email senha), conf) -> do
            if senha == conf then do 
                runDB $ insert usuario
                setMessage [shamlet|
                    <span class="label label-success">
                            Usuário criado com sucesso!
                |]
                redirect UsuarioR
            else do
                setMessage [shamlet|
                    <span class="label label-warning">
                        Senhas não conferem!
                |]
                redirect UsuarioR
        _ -> redirect HomeR