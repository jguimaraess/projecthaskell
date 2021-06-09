{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Servico where

import Import
import Handler.Auxiliar

formServico :: Maybe Servico -> Form Servico
formServico sv = renderBootstrap $ Servico
        <$> areq textField "Tipo de Serviço: " (fmap servicoNome sv)
        <*> areq intField "Preço: "  (fmap servicoPreco sv)

getServicoR :: Handler Html
getServicoR = do
    usuario <- lookupSession "_ID"
    (widget,_) <- generateFormPost (formServico Nothing)
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
        setTitle "Cadastro de Serviços"
        (formWidget widget msg ServicoR "Cadastrar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")

postServicoR :: Handler Html
postServicoR = do
    ((result,_),_) <- runFormPost (formServico Nothing)
    case result of
        FormSuccess servico -> do
            runDB $ insert servico
            setMessage [shamlet|
                <span class="label label-success">
                    Serviço inserido no sistema com sucesso!
            |]
            redirect ListarServicosR
        _ -> redirect HomeR

getListarServicosR :: Handler Html
getListarServicosR = do
    usuario <- lookupSession "_ID"
    servicos <- runDB $ selectList [] [Asc ServicoNome]
    defaultLayout $ do
                addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
                addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
                addStylesheet (StaticR css_styles_css)
                $(whamletFile "templates/listarServiços.hamlet")
                $(whamletFile "templates/footer.hamlet")
                $(whamletFile "templates/copyright.hamlet")

getEditarServR :: ServicoId -> Handler Html
getEditarServR sid = do
    usuario <- lookupSession "_ID"
    servico <- runDB $ get404 sid
    (widget,_) <- generateFormPost (formServico (Just servico))
    msg <- getMessage
    defaultLayout $ do
        addStylesheetRemote "http://remote-bootstrap-path.css"
        addScriptRemote "https://code.jquery.com/jquery-3.6.0.js"
        addScriptRemote "http://code.jquery.com/jquery-3.6.0.min.js"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"

        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        addStylesheet (StaticR css_profile_css)
        setTitle "Edição de Informações do Serviço"
        (formWidget widget msg (EditarServR sid) "Editar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")

postEditarServR :: ServicoId -> Handler Html
postEditarServR sid = do
    servicoAntigo <- runDB $ get404 sid
    ((result,_),_) <- runFormPost (formServico Nothing)
    case result of
        FormSuccess novoServico -> do
            runDB $ replace sid novoServico
            redirect ListarServicosR
        _ -> redirect HomeR

postApagarServR :: ServicoId -> Handler Html
postApagarServR sid = do
    runDB $ delete sid
    defaultLayout $ do
        addStylesheet (StaticR css_styles_css)
        setMessage [shamlet|
        <span class="label label-success">
            Serviço deletado com sucesso!
            |]
    redirect ListarServicosR
