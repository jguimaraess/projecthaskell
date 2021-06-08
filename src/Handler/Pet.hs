{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Pet where

import Import
import Handler.Auxiliar

formPet :: Maybe Pet -> Form Pet
formPet mp = renderBootstrap $ Pet
        <$> areq textField "Nome: "  (fmap petNome mp)
        <*> areq textField "Raça: "  (fmap petRaca mp)
        <*> areq intField  "Idade: " (fmap petIdade mp)
        <*> areq textField "Porte: " (fmap petPorte mp)

getPetR :: Handler Html
getPetR = do
    usuario <- lookupSession "_ID"
    (widget,_) <- generateFormPost (formPet Nothing)
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
        setTitle "Cadastro de Pet"
        (formWidget widget msg PetR "Cadastrar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")

postPetR :: Handler Html
postPetR = do
    ((result,_),_) <- runFormPost (formPet Nothing)
    case result of
        FormSuccess pet -> do 
            runDB $ insert pet 
            setMessage [shamlet|
                <span class="label label-success">
                        Cadastro de Pet feito com sucesso!
            |]
            redirect ListarPetR
        _ -> redirect HomeR

getListarPetR :: Handler Html
getListarPetR = do
    usuario <- lookupSession "_ID"
    pets <- runDB $ selectList [] [Asc PetNome]
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
                $(whamletFile "templates/listarPets.hamlet")
                $(whamletFile "templates/footer.hamlet")
                $(whamletFile "templates/copyright.hamlet")

postApagarPetR :: PetId -> Handler Html
postApagarPetR pid = do
    runDB $ delete pid
    defaultLayout $ do
            setMessage [shamlet|
                <span class="label label-success">
                    Informações do PET deletadas com sucesso!
                    |]
            redirect ListarPetR
            $(whamletFile "templates/footer.hamlet")
            $(whamletFile "templates/copyright.hamlet")

getEditarPetR :: PetId -> Handler Html
getEditarPetR pid = do
    pet <- runDB $ get404 pid
    (widget,_) <- generateFormPost (formPet (Just pet))
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
        setTitle "Edição de Informações do Pet"
        (formWidget widget msg (EditarPetR pid) "Editar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")

postEditarPetR :: PetId -> Handler Html
postEditarPetR pid = do
    _ <- runDB $ get404 pid
    ((result,_),_) <- runFormPost (formPet Nothing)
    case result of
        FormSuccess novoPet -> do
            runDB $ replace pid novoPet
            redirect ListarPetR
        _ -> redirect HomeR
