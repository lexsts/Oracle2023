SELECT /*+PARALLEL(64)*/ DISTINCT
    'SIMPL' cod_grupo_extracao,
    conta_participante.cod_conta_participante             cod_conta_participante,
    substr(conta_participante.cod_conta_participante, 1,(instr(conta_participante.cod_conta_participante, '.') - 1)) cod_participante
    ,
    conta_participante.nom_conta_participante             nome_conta_participante,
    nvl(entidade_participante.nome_entidade, rel_particip.nome_entidade) nome_participante,
    nvl(entidade_participante.nom_simplificado_entidade, rel_particip.nom_simplificado_entidade) nome_simplificado_participante,
    nvl(pj_participante.cod_nacional_pj, rel_particip.cod_nacional_pj) cod_cnpj_participante,
    conta_comitente.cod_conta_deposito                    cod_conta_depositante,
    conta_comitente.num_conta_participante                num_conta_participante,
    ( --ALTERADO
        SELECT
            conta.cod_conta
        FROM
            CETIP.TMP_cod_conta_selic conta
        WHERE
            conta.num_id_entidade = relacao.num_id_entidade_para            
    ) cod_conta_comitente_selic,
    conta_responsavel.num_conta_participante_para         cod_conta_responsavel_cadastro,
    CASE relacao.num_id_tipo_relacao
        WHEN 56   THEN
            (
                SELECT
                    replace(translate(pf.cod_cpf, './-', ' /ALTERADO'), ' ', '')
                FROM
                    cetip.pessoa_fisica pf
                WHERE
                    relacao.num_id_entidade = pf.num_id_entidade
            )
        WHEN 57   THEN
            (
                SELECT
                    replace(translate(pj.cod_nacional_pj, './-', ' '), ' ', '')
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    relacao.num_id_entidade = pj.num_id_entidade
            )
        WHEN 92   THEN
            (
                SELECT
                    replace(translate(pj.cod_nacional_pj, './-', ' '), ' ', '')
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    relacao.num_id_entidade = pj.num_id_entidade
            )
    END num_cpf_cnpj_comitente,
    CASE relacao.num_id_tipo_relacao
        WHEN 56   THEN
            (
                SELECT
                    pf.cod_cpf
                FROM
                    cetip.pessoa_fisica pf
                WHERE
                    relacao.num_id_entidade = pf.num_id_entidade
            )
        WHEN 57   THEN
            (
                SELECT
                    pj.cod_nacional_pj
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    relacao.num_id_entidade = pj.num_id_entidade
            )
        WHEN 92   THEN
            (
                SELECT
                    pj.cod_nacional_pj
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    relacao.num_id_entidade = pj.num_id_entidade
            )
    END cod_cpf_cnpj_comitente,
    entidade_comitente.nome_entidade                      nome_razao_social_comitente,
    entidade_comitente.nom_simplificado_entidade          nome_simplificado_comitente,
    ( --ALTERADA
        SELECT
            pf.nom_tipo_documento
        FROM
            CETIP.TMP_nome_tipo_doc    pf
        WHERE pf.num_id_entidade = relacao.num_id_entidade
    ) nome_tipo_documento_identidade,
    (
        SELECT
            pf.cod_doc_identidade
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) num_documento_identificacao,
    (
        SELECT
            pf.dat_emissao_doc_identidade
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) data_emissao_documento,
    (
        SELECT
            pf.nom_orgao_expedidor
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) nome_orgao_expedidor_documento,
    comitente.num_id_entidade                             num_identificador_comitente,
    CASE relacao.num_id_tipo_relacao
        WHEN 56   THEN
            'PF'
        WHEN 57   THEN
            'PJ'
        WHEN 92   THEN
            'PJ'
    END cod_tipo_pessoa,
    (
        SELECT
            pf.cod_sexo
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) cod_sexo,
    CASE
        WHEN relacao.num_id_tipo_relacao = 56 THEN
            (
                SELECT
                    pf.dat_nascimento
                FROM
                    cetip.pessoa_fisica pf
                WHERE
                    pf.num_id_entidade = relacao.num_id_entidade
            )
        WHEN relacao.num_id_tipo_relacao = 57 THEN
            (
                SELECT
                    pj.dat_constituicao_nire
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    pj.num_id_entidade = relacao.num_id_entidade
            )
    END data_nascimento,
    nvl(pais.nom_pais,
        CASE relacao.num_id_tipo_relacao
            WHEN 56   THEN
                (
                    SELECT
                        p.nom_pais
                    FROM
                        cetip.pais            p, cetip.pessoa_fisica   pf
                    WHERE
                        pf.num_id_entidade = relacao.num_id_entidade
                        AND p.num_id_pais = pf.num_id_pais
                )
            WHEN 57   THEN
                (
                    SELECT
                        p.nom_pais
                    FROM
                        cetip.pais              p, cetip.pessoa_juridica   pj
                    WHERE
                        pj.num_id_entidade = relacao.num_id_entidade
                        AND p.num_id_pais = pj.num_id_pais
                )
            WHEN 92   THEN
                (
                    SELECT
                        p.nom_pais
                    FROM
                        cetip.pais              p, cetip.pessoa_juridica   pj
                    WHERE
                        pj.num_id_entidade = relacao.num_id_entidade
                        AND p.num_id_pais = pj.num_id_pais
                )
        END
    ) nome_pais_origem_comitente,
    (
        SELECT
            uf.sig_uf
        FROM
            cetip.pessoa_fisica   pf,
            cetip.uf              uf,
            cetip.municipio       m
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
            AND m.num_id_uf = uf.num_id_uf
            AND pf.num_id_municipio = m.num_id_municipio
    ) sigl_estado_naturalidade,
    (
        SELECT
            m.nom_municipio
        FROM
            cetip.pessoa_fisica   pf,
            cetip.municipio       m
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
            AND pf.num_id_municipio = m.num_id_municipio
    ) nome_municipio_naturalidade,
    (
        SELECT
            ec.nom_estado_civil
        FROM
            cetip.pessoa_fisica   pf,
            cetip.estado_civil    ec
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
            AND pf.num_id_estado_civil = ec.num_id_estado_civil
    ) desc_estado_civil,
    (
        SELECT
            pf.ind_ppe
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) ind_ppe,
    (
        SELECT
            pf.nom_mae
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) nome_mae,
    (
        SELECT
            pf.nom_pai
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) nome_pai,
    (
        SELECT
            num_id_atividade_pf
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
    ) cod_ocupacao_profissional,
    (
        SELECT
            apf.nom_atividade_pf
        FROM
            cetip.atividade_pf    apf,
            cetip.pessoa_fisica   pf
        WHERE
            pf.num_id_entidade = relacao.num_id_entidade
            AND apf.num_id_atividade_pf = pf.num_id_atividade_pf
    ) nome_ocupacao_principal,
    (
        SELECT
            ae.nom_atividade_economica
        FROM
            cetip.pessoa_juridica       pj,
            cetip.atividade_economica   ae
        WHERE
            pj.num_id_atividade_economica = ae.num_id_atividade_economica (+)
            AND pj.num_id_entidade = relacao.num_id_entidade
    ) nome_atividade_economica,
    comitente.nom_grupo_economico_comitente               nome_grupo_economico_comitente,
    (
        SELECT
            ae.cod_cnae
        FROM
            cetip.pessoa_juridica       pj,
            cetip.atividade_economica   ae
        WHERE
            pj.num_id_atividade_economica = ae.num_id_atividade_economica (+)
            AND pj.num_id_entidade = relacao.num_id_entidade
    ) cod_cnae,
    ( --ALTERADO
        SELECT
            em.nom_email
        FROM
            cetip.e_mail em
        WHERE
            em.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_desc_email_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para                    
            )
            AND em.ind_excluido = 'N'
    ) desc_email_comitente,
    ( --ALTERADO
        SELECT
            em.nom_tipo_email
        FROM
            cetip.e_mail em
        WHERE
            em.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_desc_email_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para                    
            )
            AND em.ind_excluido = 'N'
    ) nome_tipo_email_comitente,
    ( --ALTERADO
        SELECT
            e.nom_identificador_endereco
        FROM
            cetip.endereco e
        WHERE
            e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para                    
            )
            AND e.ind_excluido = 'N'
    ) nome_tipo_endereco_comitente,
    CASE relacao.num_id_tipo_relacao
        WHEN 56   THEN
            (
                SELECT
                    pf.num_id_pais
                FROM
                    cetip.pessoa_fisica pf
                WHERE
                    pf.num_id_entidade = relacao.num_id_entidade
            )
        WHEN 57   THEN
            (
                SELECT
                    pj.num_id_pais
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    pj.num_id_entidade = relacao.num_id_entidade
            )
        WHEN 92   THEN
            (
                SELECT
                    pj.num_id_pais
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    pj.num_id_entidade = relacao.num_id_entidade
            )
    END cod_pais_endereco,
    CASE relacao.num_id_tipo_relacao
        WHEN 56   THEN
            (
                SELECT
                    p.nom_pais
                FROM
                    cetip.pais            p,
                    cetip.pessoa_fisica   pf
                WHERE
                    pf.num_id_entidade = relacao.num_id_entidade
                    AND p.num_id_pais = pf.num_id_pais
            )
        WHEN 57   THEN
            (
                SELECT
                    p.nom_pais
                FROM
                    cetip.pais              p,
                    cetip.pessoa_juridica   pj
                WHERE
                    pj.num_id_entidade = relacao.num_id_entidade
                    AND p.num_id_pais = pj.num_id_pais
            )
        WHEN 92   THEN
            (
                SELECT
                    p.nom_pais
                FROM
                    cetip.pais              p,
                    cetip.pessoa_juridica   pj
                WHERE
                    pj.num_id_entidade = relacao.num_id_entidade
                    AND p.num_id_pais = pj.num_id_pais
            )
    END nome_pais_endereco_comitente,
    (--ALTERADO
        SELECT
            reg.sig_regiao
        FROM
            cetip.endereco    e,
            cetip.municipio   m,
            cetip.uf          uf,
            cetip.regiao      reg
        WHERE
            m.num_id_municipio (+) = e.num_id_municipio
            AND uf.num_id_uf (+) = m.num_id_uf
            AND uf.num_id_regiao = reg.num_id_regiao (+)
            AND e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) sigl_regiao_geografica,
    (--ALTERADO
        SELECT
            reg.nom_regiao
        FROM
            cetip.endereco    e,
            cetip.municipio   m,
            cetip.uf          uf,
            cetip.regiao      reg
        WHERE
            m.num_id_municipio (+) = e.num_id_municipio
            AND uf.num_id_uf (+) = m.num_id_uf
            AND uf.num_id_regiao = reg.num_id_regiao (+)
            AND e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) nome_regiao_geografica,
    (--ALTERADO
        SELECT
            uf.sig_uf
        FROM
            cetip.endereco    e,
            cetip.municipio   m,
            cetip.uf          uf
        WHERE
            m.num_id_municipio (+) = e.num_id_municipio
            AND uf.num_id_uf (+) = m.num_id_uf
            AND e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) sigl_estado_endereco_comitente,
    (--ALTERADO
        SELECT
            m.cod_municipio
        FROM
            cetip.endereco    e,
            cetip.municipio   m
        WHERE
            m.num_id_municipio (+) = e.num_id_municipio
            AND e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) cod_municipio_endereco,
    (--ALTERADO
        SELECT
            m.nom_municipio
        FROM
            cetip.endereco    e,
            cetip.municipio   m
        WHERE
            m.num_id_municipio (+) = e.num_id_municipio
            AND e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) nome_municipio_endereco,
    (--ALTERADO
        SELECT
            lpad(replace(e.cod_cep, '-', ''), 8, '0')
        FROM
            cetip.endereco e
        WHERE
            e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) cod_cep_comitente,
    (--ALTERADO
        SELECT
            e.nom_bairro
        FROM
            cetip.endereco e
        WHERE
            e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) nome_bairro_comitente,
    (--ALTERADO
        SELECT
            e.nom_logradouro
        FROM
            cetip.endereco e
        WHERE
            e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) nome_logradouro_comitente,
    (--ALTERADO
        SELECT
            e.num_logradouro
        FROM
            cetip.endereco e
        WHERE
            e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) num_logradouro_comitente,
    (--ALTERADO
        SELECT
            e.nom_complemento
        FROM
            cetip.endereco e
        WHERE
            e.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_comitente   mce_em
                WHERE
                    mce_em.num_id_entidade = relacao.num_id_entidade_para  
            )
            AND e.ind_excluido = 'N'
    ) nome_complemento_comitente,
    (--ALTERADO
        SELECT
            t.nom_tipo_telefone
        FROM
            cetip.telefone t
        WHERE
            t.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_TELEFONE   mce_em
                WHERE mce_em.num_id_entidade = relacao.num_id_entidade_para
                                )
            AND t.ind_excluido = 'N'
    ) nome_tipo_telefone_comitente,
    (--ALTERADO
        SELECT
            t.num_ddd
        FROM
            cetip.telefone t
        WHERE
            t.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_TELEFONE   mce_em
                WHERE mce_em.num_id_entidade = relacao.num_id_entidade_para
            )
            AND t.ind_excluido = 'N'
    ) num_ddd_comitente,
    (--ALTERADO
        SELECT
            t.num_telefone
        FROM
            cetip.telefone t
        WHERE
            t.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_TELEFONE   mce_em
                WHERE mce_em.num_id_entidade = relacao.num_id_entidade_para
            )
            AND t.ind_excluido = 'N'
    ) num_telefone_comitente,
    (--ALTERADO
        SELECT
            t.num_ramal
        FROM
            cetip.telefone t
        WHERE
            t.num_id_meio_comunicacao IN (
                SELECT
                    mce_em.num_id_meio_comunicacao
                FROM
                    CETIP.TMP_NOME_TIPO_TELEFONE   mce_em
                WHERE mce_em.num_id_entidade = relacao.num_id_entidade_para
            )
            AND t.ind_excluido = 'N'
    ) num_ramal_comitente,
    condicao_tributaria.nom_condicao_tributaria           nome_natureza_fiscal,
    comitente.num_id_tipo_invest_estrangeiro              cod_tipo_estrangeiro,
    tipo_invest_estrangeiro.nom_tipo_invest_estrangeiro   nome_tipo_estrangeiro,
    CASE relacao.num_id_tipo_relacao
        WHEN 56   THEN
            (
                SELECT
                    pf.cod_cvm
                FROM
                    cetip.pessoa_fisica pf
                WHERE
                    relacao.num_id_entidade = pf.num_id_entidade
            )
        WHEN 57   THEN
            (
                SELECT
                    pj.cod_cvm
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    relacao.num_id_entidade = pj.num_id_entidade
            )
        WHEN 92   THEN
            (
                SELECT
                    pj.cod_cvm
                FROM
                    cetip.pessoa_juridica pj
                WHERE
                    relacao.num_id_entidade = pj.num_id_entidade
            )
    END cod_cvm_investidor_estrangeiro,
    comitente_inr.cod_nif                                 cod_nif,
    jurisdicao.cod_jurisdicao                             cod_jurisdicao_comitente,
    (
        SELECT
            pj.cod_nacional_pj
        FROM
            cetip.pessoa_juridica   pj,
            cetip.relacao           r
        WHERE
            pj.num_id_entidade = r.num_id_entidade
            AND r.num_id_entidade_para = comitente.num_id_entidade
            AND r.num_id_tipo_relacao IN (
                86,
                87
            )
            AND r.dat_exclusao IS NULL
    ) num_cpf_cnpj_representante,
    (
        SELECT
            pj.cod_nacional_pj
        FROM
            cetip.pessoa_juridica   pj,
            cetip.relacao           r
        WHERE
            pj.num_id_entidade = r.num_id_entidade
            AND r.num_id_entidade_para = comitente.num_id_entidade
            AND r.num_id_tipo_relacao = 88
            AND r.dat_exclusao IS NULL
    ) num_cnpj_co_representante,
    comitente.cod_participante_cls                        cod_participante_clearstream,
    situacao_comitente.ind_bloqueia_operacao              ind_bloqueio_operacao,
    comitente.num_id_situacao_comitente                   ind_cadastro_basico_atualizado,
    DECODE(comitente.ind_comitente_simplificado, 'S', 'SIM', 'NAO') ind_cadastro_simplificado,
    comitente.ind_enviado_ecs                             ind_enviado_ecs,
    comitente.ind_excluido                                ind_exclusao,
    jurisdicao.nom_jurisdicao                             nome_jurisdicao_comitente,
    situacao_comitente.nom_situacao_comitente             nome_situacao_comitente,
    comitente.dat_alteracao                               data_inclusao_atualizacao,
    CASE
        WHEN (
            SELECT
                MAX(cod_acao)
            FROM
                cetip.hist_atualiz_comitente vhist
            WHERE
                vhist.cod_acao IN (
                    'AD',
                    'ID',
                    'CD'
                )
                AND vhist.num_id_comitente = comitente.num_id_entidade
        ) IS NULL THEN
            'AD'
        ELSE
            (
                SELECT
                    MAX(cod_acao)
                FROM
                    cetip.hist_atualiz_comitente vhist
                WHERE
                    vhist.cod_acao IN (
                        'AD',
                        'ID',
                        'CD'
                    )
                    AND vhist.num_id_comitente = comitente.num_id_entidade
            )
    END AS nome_tipo_movimento_registro,
    comitente.dat_inclusao                                data_inclusao,
    NULL data_efetivacao_fim,
    NULL data_efetivacao_inicio,
    (
        SELECT
            p.nom_pais
        FROM
            cetip.pais p
        WHERE
            p.num_id_pais = comitente.num_id_pais_nacionalidade
    ) nome_nacionalidade_comitente,
    (
        SELECT
            pj.num_id_atividade_economica
        FROM
            cetip.pessoa_juridica pj
        WHERE
            pj.num_id_entidade = relacao.num_id_entidade
    ) num_atividade_economica,
    comitente.ind_vinculado                               ind_vinculado
FROM
    cetip.comitente                                                                                                                                                                                                                                                                                                             comitente,
    (
        SELECT
            pj.cod_nacional_pj,
            r.num_id_entidade_para,
            ent_par.nome_entidade,
            ent_par.nom_simplificado_entidade
        FROM
            cetip.pessoa_juridica   pj,
            cetip.relacao           r,
            cetip.entidade          ent_par
        WHERE
            pj.num_id_entidade = r.num_id_entidade
            AND r.dat_exclusao IS NULL
            AND ent_par.num_id_entidade = r.num_id_entidade
            AND r.num_id_tipo_relacao IN (
                56,
                57,
                92
            )
    ) rel_particip,
    cetip.entidade                                                                                                                                                                                                                                                                                                              entidade_comitente,
    cetip.conta_participante                                                                                                                                                                                                                                                                                                    conta_participante,
    cetip.entidade                                                                                                                                                                                                                                                                                                              entidade_participante,
    cetip.pessoa_juridica                                                                                                                                                                                                                                                                                                       pj_participante,
    cetip.conta_comitente                                                                                                                                                                                                                                                                                                       conta_comitente,
    (
        SELECT
            rccart.num_conta_participante_para,
            rccart.num_conta_participante
        FROM
            cetip.relacao_contas   rccart,
            cetip.relacao          rcart
        WHERE
            rccart.num_id_relacao = rcart.num_id_relacao
            AND rcart.num_id_tipo_relacao = 51
            AND rccart.ind_excluido = 'N'
            AND rccart.dat_exclusao IS NULL
    )                                      conta_responsavel,
    cetip.pais                                                                                                                                                                                                                                                                                                                  pais,
    cetip.condicao_tributaria                                                                                                                                                                                                                                                                                                   condicao_tributaria,
    cetip.tipo_invest_estrangeiro                                                                                                                                                                                                                                                                                               tipo_invest_estrangeiro,
    cetip.comitente_inr                                                                                                                                                                                                                                                                                                         comitente_inr,
    cetip.jurisdicao                                                                                                                                                                                                                                                                                                            jurisdicao,
    cetip.situacao_comitente                                                                                                                                                                                                                                                                                                    situacao_comitente,
    cetip.relacao,
    (
        SELECT
            pf.num_id_entidade num_id_entidade
        FROM
            cetip.pessoa_fisica pf
        WHERE
            pf.cod_cpf IS NOT NULL
        UNION
        SELECT
            pj.num_id_entidade num_id_entidade
        FROM
            cetip.pessoa_juridica pj
        WHERE
            pj.cod_nacional_pj IS NOT NULL
    )                                                                                                    pf_pj
WHERE
    relacao.num_id_entidade = pf_pj.num_id_entidade
    AND comitente.num_id_entidade = rel_particip.num_id_entidade_para (+)
    AND conta_participante.num_conta_participante = conta_comitente.num_conta_participante
    AND conta_participante.num_id_entidade = entidade_participante.num_id_entidade (+)
    AND entidade_participante.num_id_entidade = pj_participante.num_id_entidade (+)
    AND comitente.num_id_entidade = conta_comitente.num_id_entidade (+)
    AND conta_participante.num_conta_participante = conta_responsavel.num_conta_participante (+)
    AND comitente.num_id_pais = pais.num_id_pais (+)
    AND comitente.num_id_tipo_invest_estrangeiro = tipo_invest_estrangeiro.num_id_tipo_invest_estrangeiro (+)
    AND comitente.num_id_entidade = comitente_inr.num_id_entidade (+)
    AND comitente.num_id_jurisdicao = jurisdicao.num_id_jurisdicao (+)
    AND comitente.num_id_situacao_comitente = situacao_comitente.num_id_situacao_comitente (+)
    AND comitente.num_id_condicao_tributaria = condicao_tributaria.num_id_condicao_tributaria (+)
    AND relacao.num_id_entidade_para = comitente.num_id_entidade
    AND relacao.num_id_tipo_relacao IN (
        56,
        57,
        92
    )
    AND relacao.ind_excluido = 'N'
    AND relacao.num_id_entidade = entidade_comitente.num_id_entidade (+)
    AND comitente.ind_comitente_simplificado = 'S'