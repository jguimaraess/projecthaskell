{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Agendar where

import Import
import Handler.Auxiliar
import Database.Persist.Postgresql

servicoCB = do
    servicos <- runDB $ selectList [] [Asc ServicoNome]
    optionsPairs $
        map (\r -> (servicoNome $ entityVal r, entityKey r)) servicos

clienteCB = do
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    optionsPairs $
        map (\r -> (clienteNome $ entityVal r, entityKey r)) clientes

petCB = do
    pets <- runDB $ selectList [] [Asc PetNome]
    optionsPairs $
        map (\r -> (petNome $ entityVal r, entityKey r)) pets

formAgendar :: Form Agendar
formAgendar = renderBootstrap $ Agendar
    <$> areq intField "Ordem: " Nothing
    <*> areq (selectField servicoCB) "Serviço: " Nothing
    <*> areq (selectField clienteCB) "Cliente: " Nothing
    <*> areq (selectField petCB) "Pet: " Nothing
    <*> areq dayField "Dia: " Nothing
    <*> areq textField "Hora: " Nothing

getAgendarR :: Handler Html
getAgendarR = do
    (widget, _) <- generateFormPost formAgendar
    msg <- getMessage
    defaultLayout $ do
        usuario <- lookupSession "_ID"
        addStylesheet (StaticR css_bootstrap_css)
        addStylesheet (StaticR css_styles_css)
        setTitle "Agendamento"
        [whamlet|
            $maybe email <- usuario
                <form action=@{SairR} method=post> 
                    #{email}: <input type="submit" value="Sair">
        |]
        (formWidget widget msg AgendarR "Agendar")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")
    
postAgendarR :: Handler Html
postAgendarR = do
    ((result,_),_) <- runFormPost formAgendar
    case result of
        FormSuccess agendar -> do
            runDB $ insert agendar
            setMessage [shamlet|
                <span class="label label-success">
                    Data e Hora Agendadas com sucesso!
            |]
            redirect AgendarR
        _ -> redirect HomeR

getListarAgendaR :: ClienteId -> Handler Html
getListarAgendaR cid = do
    let sql = "SELECT ??,??,??,??,?? FROM agendar \
            \ INNER JOIN servico ON servico.id = agendar.servid \
            \ INNER JOIN cliente ON cliente.id = agendar.cliid \
            \ INNER JOIN pet ON pet.id = agendar.petid \
            \ WHERE cliente.id = ?"
    cliente <- runDB $ get404 cid
    agenda <- runDB $ rawSql sql [toPersistValue cid] :: Handler [(Entity Agendar, Entity Servico, Entity Cliente, Entity Pet, Entity Agendar)]
    defaultLayout $ do
        usuario <- lookupSession "_ID"
        addStylesheet (StaticR css_styles_css)
        $(whamletFile "templates/listarAgenda.hamlet")
        $(whamletFile "templates/footer.hamlet")
        $(whamletFile "templates/copyright.hamlet")
        
        



