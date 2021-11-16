--700038180,700038181,700038188
DECLARE @Seql_PreLojaOriginal INT                  = 700038181                           -- Loja Origem
DECLARE @Seql_Marketpalce     INT                  = 55                          -- Marketplace Destino
DECLARE @Seql_PreLoja         INT                  = 0                           -- Pré-loja destino
DECLARE @Cod_StatusPreLoja    INT                  = 1                           -- NOVO
DECLARE @Cod_StatusRegistro   INT                  = 1                           -- ATIVO
DECLARE @Nom_MotivoStatus     VARCHAR  (5000)      = 'COPIADO VIA SCRIPT SQL'    -- Motivo

IF @Seql_PreLoja = 0 AND @Seql_PreLojaOriginal  > 0 AND @Seql_Marketpalce > 0 AND EXISTS (SELECT TOP 1 1 
                                                                                             FROM dbo.MGM_Marketplace 
                                                                                             WHERE Seql_Marketplace = @Seql_Marketpalce)
BEGIN
   BEGIN TRY
      
      BEGIN TRAN

      INSERT INTO dbo.MGM_PreLoja (Cod_Acquirer,Seql_SubAcquirer,Seql_Marketplace,Nom_PreLoja,Nom_Fantasia,Cod_TipoPreLoja,
                Num_CPFCNPJ,Cod_TipoPes,Num_InscrEstl, Cod_NatJuridica,Cod_CNAE, Cod_TipoDoc, Num_Documento,Dat_ExpedDoc,
                Dat_ValidDoc,Nom_OrgaoExped,Cod_UFExped,Nom_Nacionalidade,Nom_Pai,Nom_Mae,Dat_Nasc,Nom_CidadeNasc,Cod_UFNasc,
                Nom_PPE,Nom_Email,Nom_Cont,Vlr_RendaMensal,Vlr_Patrimonio,Vlr_LimiteDiario,Vlr_LimiteMensal,
                Ind_AceitouContrato,Ind_UsaLimite,Ind_AssumeComissao,Ind_AssumeChargeback,Ind_PreLojaPropria,
                Seql_PlanoPagto,Cod_StatusPreLoja,Nom_UrlCallBack,Inst_Criacao,Inst_UltAlt,Cod_StatusRegistro,Seql_UsuarioCriacao,
                Seql_UsuarioUltAlt,Vlr_CapitalSocial,Cod_StatusReceita,
                Dat_StatusReceita,Num_MerchantID,Num_QualificacaoID,Nom_MotivoStatus,Nom_ProfissaoAtividade,Cod_PaisNasc,
                Cod_EstadoCivil,Cod_Sexo,Nom_Conjuge,Cod_PPE,
                Ind_AntecipAutomatica, Vlr_FaturamentoAnual, Dat_FaturamentoAnual)
         SELECT Cod_Acquirer,Seql_SubAcquirer,@Seql_Marketpalce,Nom_PreLoja,Nom_Fantasia,1,
                Num_CPFCNPJ,Cod_TipoPes,Num_InscrEstl, Cod_NatJuridica,Cod_CNAE, Cod_TipoDoc, Num_Documento,Dat_ExpedDoc,
                Dat_ValidDoc,Nom_OrgaoExped,Cod_UFExped,Nom_Nacionalidade,Nom_Pai,Nom_Mae,Dat_Nasc,Nom_CidadeNasc,Cod_UFNasc,
                Nom_PPE,Nom_Email,Nom_Cont,Vlr_RendaMensal,Vlr_Patrimonio,Vlr_LimiteDiario,Vlr_LimiteMensal,
                Ind_AceitouContrato,Ind_UsaLimite,Ind_AssumeComissao,Ind_AssumeChargeback,Ind_PreLojaPropria,
                Seql_PlanoPagto,@Cod_StatusPreLoja,Nom_UrlCallBack,getdate(),getdate(),@Cod_StatusRegistro,Seql_UsuarioCriacao,
                Seql_UsuarioUltAlt,Vlr_CapitalSocial,Cod_StatusReceita,
                Dat_StatusReceita,NULL,NULL,@Nom_MotivoStatus,Nom_ProfissaoAtividade,Cod_PaisNasc,
                Cod_EstadoCivil,Cod_Sexo,Nom_Conjuge,Cod_PPE,
                Ind_AntecipAutomatica, Vlr_FaturamentoAnual, Dat_FaturamentoAnual
            FROM dbo.MGM_PreLoja 
            WHERE Seql_PreLoja = @Seql_PreLojaOriginal

      IF @@rowcount > 0
      BEGIN
         SELECT @Seql_PreLoja = coalesce (scope_identity (), @Seql_PreLoja)
      END   

      IF @Seql_PreLoja > 0
      BEGIN

         INSERT INTO dbo.MGM_PreLojaBandeiraProduto (Seql_PreLoja,Cod_BandeiraProduto,Cod_Bco,
                   Num_Agencia,Nom_DgAgencia,Num_Conta,Nom_DgConta,Cod_TipoConta,Inst_Criacao,
                   Inst_UltAlt,Seql_UsuarioCriacao,Seql_UsuarioUltAlt,Cod_StatusRegistro)
            SELECT @Seql_PreLoja,Cod_BandeiraProduto,Cod_Bco,
                   Num_Agencia,Nom_DgAgencia,Num_Conta,Nom_DgConta,Cod_TipoConta,getdate(),
                   getdate(),Seql_UsuarioCriacao,Seql_UsuarioUltAlt, Cod_StatusRegistro
               FROM dbo.MGM_PreLojaBandeiraProduto 
               WHERE Seql_PreLoja       = @Seql_PreLojaOriginal

         INSERT INTO dbo.MGM_PreTaxaSubLoja (Seql_PreLoja,
                   Seql_PlanoPagto,Cod_TipoTran,Cod_BandeiraProduto,Num_Parcelas,Dat_Valid,Perc_MDRLoja,
                   Inst_Criacao,Inst_UltAlt,Cod_StatusRegistro,Seql_UsuarioCriacao,Seql_UsuarioResponsavel,
                   Seql_GrupoResponsavel,Seql_UsuarioUltAlt,Vlr_MDRLoja,Vlr_MaxMDRLoja)
            SELECT @Seql_PreLoja,
                   Seql_PlanoPagto,Cod_TipoTran,Cod_BandeiraProduto,Num_Parcelas,Dat_Valid,Perc_MDRLoja,
                   getdate(),getdate(),Cod_StatusRegistro,Seql_UsuarioCriacao,Seql_UsuarioResponsavel,
                   Seql_GrupoResponsavel,Seql_UsuarioUltAlt,Vlr_MDRLoja,Vlr_MaxMDRLoja
               FROM MGM_PreTaxaSubLoja 
               WHERE Seql_PreLoja       = @Seql_PreLojaOriginal
                 AND Cod_StatusRegistro = @Cod_StatusRegistro

         INSERT INTO dbo.MGM_PreLojaEndereco (Seql_PreLoja,Cod_TipoEndereco,Nom_Endereco,Num_Endereco,
                   Nom_Bairro,Nom_Cidade,Cod_UF,Num_CEP,Nom_Complemento,Nom_PontoReferencia,Cod_StatusRegistro)
            SELECT @Seql_PreLoja,Cod_TipoEndereco,Nom_Endereco,Num_Endereco,
                   Nom_Bairro,Nom_Cidade,Cod_UF,Num_CEP,Nom_Complemento,Nom_PontoReferencia,Cod_StatusRegistro 
               FROM MGM_PreLojaEndereco 
               WHERE Seql_PreLoja       = @Seql_PreLojaOriginal
                 AND Cod_StatusRegistro = @Cod_StatusRegistro

         INSERT INTO dbo.MGM_PreLojaTelefone (Seql_PreLoja,Cod_TipoTelefone,Num_DDI,
                   Num_DDD,Num_Telefone,Cod_StatusRegistro)
            SELECT @Seql_PreLoja,Cod_TipoTelefone,Num_DDI,
                   Num_DDD,Num_Telefone, Cod_StatusRegistro
               FROM MGM_PreLojaTelefone 
               WHERE Seql_PreLoja       = @Seql_PreLojaOriginal
                 AND Cod_StatusRegistro = @Cod_StatusRegistro

         INSERT INTO dbo.MGM_PreLojaRepresentante (Seql_PreLoja,Nom_PreLojaRepresentante,Num_CPF,Dat_Nasc,
                   Cod_Sexo,Cod_EstadoCivil,Num_DocumentoConjuge,Dat_NascConjuge,Cod_SexoConjuge,Cod_Naturalidade,
                   Nom_Naturalidade,Nom_Pai,Nom_Mae,Cod_Cidade,Nom_Cidade,Cod_UF,Nom_ProfissaoPrincipal,Cod_TipoDoc,
                   Num_Doc,Dat_ExpedDoc,Dat_ValidDoc,Nom_OrgaoExpedDoc,Cod_UFExpedDoc,Num_SerieDoc,Cod_PaisDoc,
                   Nom_PaisDoc,Cod_TipoRenda,Nom_TipoRenda,Vlr_Renda,Nom_PeriodoRenda,Nom_TipoComprovacaoRenda,
                   Dat_ReferenciaRenda,Nom_EmpresaPagadora,Vlr_Patrimonio,Inst_Criacao,Inst_UltAlt,Seql_UsuarioCriacao,
                   Seql_UsuarioUltAlt,Cod_StatusRegistro,Nom_Nacionalidade,Nom_PPE,Cod_PPE)
            SELECT @Seql_PreLoja,Nom_PreLojaRepresentante,Num_CPF,Dat_Nasc,
                   Cod_Sexo,Cod_EstadoCivil,Num_DocumentoConjuge,Dat_NascConjuge,Cod_SexoConjuge,Cod_Naturalidade,
                   Nom_Naturalidade,Nom_Pai,Nom_Mae,Cod_Cidade,Nom_Cidade,Cod_UF,Nom_ProfissaoPrincipal,Cod_TipoDoc,
                   Num_Doc,Dat_ExpedDoc,Dat_ValidDoc,Nom_OrgaoExpedDoc,Cod_UFExpedDoc,Num_SerieDoc,Cod_PaisDoc,
                   Nom_PaisDoc,Cod_TipoRenda,Nom_TipoRenda,Vlr_Renda,Nom_PeriodoRenda,Nom_TipoComprovacaoRenda,
                   Dat_ReferenciaRenda,Nom_EmpresaPagadora,Vlr_Patrimonio,getdate(),getdate(),Seql_UsuarioCriacao,
                   Seql_UsuarioUltAlt,Cod_StatusRegistro,Nom_Nacionalidade,Nom_PPE,Cod_PPE
               FROM MGM_PreLojaRepresentante 
               WHERE Seql_PreLoja       = @Seql_PreLojaOriginal
                 AND Cod_StatusRegistro = @Cod_StatusRegistro

         INSERT INTO dbo.MGM_PreLojaSocio (Seql_PreLoja,Num_CPFCNPJ,Cod_TipoPes,Nom_PreLojaSocio,
                   Num_InscrEstl,Dat_IniRelac,Perc_Particip,Cod_NatJuridica,Cod_CNAE,Cod_TipoDoc,Num_Documento,
                   Dat_ExpedDoc,Dat_ValidDoc,Nom_OrgaoExped,Cod_UFExped,Nom_Nacionalidade,Nom_Pai,Nom_Mae,Dat_Nasc,
                   Nom_CidadeNasc,Cod_UFNasc,Nom_PPE,Nom_Email,Nom_Cont,Num_DDDFone,Num_Fone,Num_DDDCel,Num_Cel,
                   Vlr_RendaMensal,Vlr_Patrimonio,Inst_Criacao,Inst_UltAlt,Cod_StatusRegistro,
                   Seql_UsuarioCriacao,Seql_UsuarioUltAlt,
                   Seql_PreLojaSocioOrigem,Cod_PPE,Cod_Sexo)
            SELECT @Seql_PreLoja,Num_CPFCNPJ,Cod_TipoPes,Nom_PreLojaSocio,
                   Num_InscrEstl,Dat_IniRelac,Perc_Particip,Cod_NatJuridica,Cod_CNAE,Cod_TipoDoc,Num_Documento,
                   Dat_ExpedDoc,Dat_ValidDoc,Nom_OrgaoExped,Cod_UFExped,Nom_Nacionalidade,Nom_Pai,Nom_Mae,Dat_Nasc,
                   Nom_CidadeNasc,Cod_UFNasc,Nom_PPE,Nom_Email,Nom_Cont,Num_DDDFone,Num_Fone,Num_DDDCel,Num_Cel,
                   Vlr_RendaMensal,Vlr_Patrimonio,getdate(),getdate(),Cod_StatusRegistro,
                   Seql_UsuarioCriacao,Seql_UsuarioUltAlt,
                   Seql_PreLojaSocioOrigem,Cod_PPE,Cod_Sexo
               FROM MGM_PreLojaSocio 
                  WITH (NOLOCK)
               WHERE Seql_PreLoja       = @Seql_PreLojaOriginal
                 AND Cod_StatusRegistro = @Cod_StatusRegistro
      END  

      COMMIT

   END TRY
   BEGIN CATCH

      SELECT ERROR_NUMBER()  AS ErrorNumber,  
             ERROR_MESSAGE() AS ErrorMessage

      ROLLBACK

   END CATCH
END

--CONFIRMAR APROVAÇÃO
SELECT * 
   FROM dbo.MGM_PreLoja 
   WHERE Seql_PreLoja     = @Seql_PreLoja
     AND Seql_Marketplace = @Seql_Marketpalce

