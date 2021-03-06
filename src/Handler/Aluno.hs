{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Aluno where

import Import
-- import Database.Persist.Postgresql

-- <$>, <*> CAP 74 do LIVRO
formAluno :: Form Aluno
formAluno = renderBootstrap $ Aluno
     <$> areq textField "Nome: " Nothing
     <*> areq textField "RA: " Nothing
     <*> areq intField "Idade: " Nothing

-- ^ coloca outro html, no caso, os inputs
getAlunoR :: Handler Html
getAlunoR = do
     (widget,enctype) <- generateFormPost formAluno
     defaultLayout $ do
          addStylesheet $ StaticR css_bootstrap_css
          [whamlet|
               <form method=post action=@{AlunoR}>
                    ^{widget}
                    <input type="submit" value="cadastrar">
                    <!-- <button> Cadastrar -->
          |]

postAlunoR :: Handler Html
postAlunoR = do
     -- LE DO FORM
     ((res,_),_) <- runFormPost formAluno
     case res of
          FormSuccess aluno -> do
               _ <- ($) runDB $ insert aluno
               redirect AlunoR
          _ -> redirect HomeR
