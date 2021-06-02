{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Cliente where

import Import
import Handler.Auxiliar
import Text.Lucius
import Text.Julius

formCliente :: Form (Cliente, Text)
formCliente = renderBootstrap $ (,)
        <$> (Cliente
        <$> areq textField "Nome Completo: " Nothing
        <*> areq emailField "Email: "  Nothing
        <*> areq intField  "CPF: " Nothing
        <*> areq textField "Endereco: "  Nothing
        <*> areq intField  "Telefone: " Nothing
        <*> areq passwordField "Senha de Usuário: "  Nothing)
    <*> areq passwordField "Confirmação de Senha: "  Nothing

getClienteR :: Handler Html
getClienteR = do
    (widget,_) <- generateFormPost formCliente
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
        setTitle "Cadastro de Cliente"
        (formWidget widget msg ClienteR "Cadastrar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")


postClienteR :: Handler Html
postClienteR = do
    ((result,_),_) <- runFormPost formCliente
    case result of
        FormSuccess (cliente@(Cliente nome email cpf endereco telefone senha), conf ) -> do 
            if senha == conf then do
                runDB $ insert cliente 
                setMessage [shamlet|
                    <span class="label label-success">
                        Usuário criado com sucesso!
                |]
                redirect ClienteR
            else do
                setMessage [shamlet|
                    <span class="label label-warning">
                        Senhas não conferem!
                |]
                redirect ClienteR
        _ -> redirect HomeR

getPerfilR :: ClienteId -> Handler Html
getPerfilR cid = do
    cliente <- runDB $ get404 cid
    defaultLayout $ do
                addScriptRemote "https://code.jquery.com/jquery-3.6.0.js"
                addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
                addScriptRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"
                addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/animejs/3.2.1/anime.min.js"
                addStylesheetRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css"
        
                addStylesheet (StaticR css_bootstrap_css)
                addStylesheet (StaticR css_styles_css)
                addStylesheet (StaticR css_profile_css)
                setTitle "Perfil Cliente"
                $(whamletFile "templates/perfilCliente.hamlet")
                $(whamletFile "templates/footer.hamlet")
                $(whamletFile "templates/copyright.hamlet")

getListarCliR :: Handler Html
getListarCliR = do
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    defaultLayout $ do
                addStylesheetRemote "http://remote-bootstrap-path.css"
                addScriptRemote "https://code.jquery.com/jquery-3.6.0.js"
                addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
                addScriptRemote "https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js"
                addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/popper.js/2.9.2/umd/popper.min.js"
                addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/jQuery.mmenu/8.5.22/mmenu.js"
                addStylesheetRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css"
                addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
                
                addStylesheet (StaticR css_styles_css)
                addStylesheet (StaticR css_bootstrap_css)
                addScript (StaticR js_scripts_js)
                $(whamletFile "templates/listarClientes.hamlet")
                $(whamletFile "templates/footer.hamlet")
                $(whamletFile "templates/copyright.hamlet")

postApagarCliR :: ClienteId -> Handler Html
postApagarCliR cid = do
    runDB $ delete cid
    defaultLayout $ do
            $(whamletFile "templates/deletarCliente.hamlet")
            $(whamletFile "templates/footer.hamlet")
            $(whamletFile "templates/copyright.hamlet")
    redirect ListarCliR

-- getEditarCliR :: ClienteId -> Handler Html
-- getEditarCliR cid = do
--     cliente <- runDB $ get404 cid
--     (widget,_) <- generateFormPost (formCliente (Just cliente))
--     msg <- getMessage
--     defaultLayout $ do
--         addStylesheetRemote "http://remote-bootstrap-path.css"
--         addScriptRemote "https://code.jquery.com/jquery-3.6.0.js"
--         addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
--         addScriptRemote "https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js"
--         addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/popper.js/2.9.2/umd/popper.min.js"
--         addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/jQuery.mmenu/8.5.22/mmenu.js"
--         addStylesheetRemote "https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css"
--         addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"

--         addStylesheet (StaticR css_bootstrap_css)
--         addStylesheet (StaticR css_styles_css)
--         addStylesheet (StaticR css_profile_css)
--         setTitle "Edição de Informações do Cliente"
--         (formWidget widget msg (EditarCliR cid) "Editar")
--         $(whamletFile "templates/footer.hamlet")
--         $(whamletFile "templates/copyright.hamlet")


-- postEditarCliR :: ClienteId -> Handler Html
-- postEditarCliR cid = do
--     _ <- runDB $ get404 cid
--     ((result,_),_) <- runFormPost (formCliente Nothing)
--     case result of
--         FormSuccess novoCliente -> do
--             runDB $ replace cid novoCliente
--             redirect ListarCliR
--         _ -> redirect HomeR

-- dadosPetR :: Handler Html
-- dadosPetR = do
--     defaultLayout $ do
--         -- estatico
--         addStylesheet (StaticR css_bootstrap_css)
--         addStylesheet (StaticR css_styles_css)
--         -- dinamico
--         --corpo html
--         $(whamletFile "templates/navbar.hamlet")
--         $(whamletFile "templates/perfilCliente.hamlet")
--         $(whamletFile "templates/footer.hamlet")
--         $(whamletFile "templates/copyright.hamlet")
--         --javascript estático
--         addScript $ (StaticR js_scripts_js)

