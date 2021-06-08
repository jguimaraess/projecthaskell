{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Handler.Auxiliar

formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
        <$> areq emailField "Email: " Nothing
        <*> areq passwordField "Senha de Usuário: "  Nothing

autenticar :: Text -> Text -> HandlerT App IO (Maybe (Entity Usuario))
autenticar email senha = runDB $ selectFirst [UsuarioEmail ==. email
                                             ,UsuarioSenha ==. senha] []

getAuthR :: Handler Html
getAuthR = do
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
        setTitle "Login de Usuário"
        (formWidget widget msg AuthR "Entrar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")


postAuthR :: Handler Html
postAuthR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess ("root@root.com", "root") -> do
            setSession "_ID" "admin"
            redirect AdminR
        FormSuccess (email,senha) -> do
            usuarioExiste <- autenticar email senha
            case usuarioExiste of
                Nothing -> do
                    setMessage [shamlet|
                        <span class="label label-warning">
                            Usuário ou senha inválidos
                    |]
                    redirect AuthR
                Just (Entity _ usuario) -> do
                    if senha == usuarioSenha usuario then do
                        setSession "_ID" (usuarioEmail usuario)
                        redirect HomeR
                    else do
                        setMessage [shamlet|
                        <span class="label label-danger">
                            Usuário e/ou Senha estão incorretos!
                        |]
                    redirect AuthR
        _ -> redirect HomeR

postSairR :: Handler Html
postSairR = do
    deleteSession "_ID"
    redirect HomeR

getAdminR :: Handler Html
getAdminR = do 
    defaultLayout $ do
        usuario <- lookupSession "_ID"
        addScriptRemote "https://code.jquery.com/jquery-3.6.0.js"
        addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"
        addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/animejs/3.2.1/anime.min.js"
        addStylesheetRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css"
        
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        addStylesheet (StaticR css_profile_css)
        setTitle "Administrador"
        $(whamletFile "templates/admin.hamlet")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")