create table cetip.tmp_cop AS
SELECT
            dat_ctl_oper
        FROM
            cetip.controle_operacional
        WHERE
            num_sistema IS NULL
            AND num_ordem = 0
			
SELECT /*+ PARALLEL(16) */
            cart.num_if,
            cart.num_conta_participante,
            cart.num_sistema,
            s.cod_sistema,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 1 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS propria_livre,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 2 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS repasse_livre,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 3 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS recompra,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 4 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS bloqueada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 7 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS nao_repactuada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 8 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS caucionada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 13 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS distribuicao_livre,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 16 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS reserva_tecnica,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 19 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS propria_bloqueada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 28 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS repasse_bloqueada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 31 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS propria_negociacao,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 40 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS bloqueada_inadimplente,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 41 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS bloqueada_venda_wa,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 33 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS distribuicao_bloqueada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 34 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS vinculada_derivativo,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 35 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS bloqueada_derivativo,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 42 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantia_penhor,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 43 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantia_cessao_fiduciaria,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 44 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 45 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_cs_fid,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 46 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantida,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 36 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS retrocessionaria,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 37 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS retrocedente_livre,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 38 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS retrocedente_bloqueada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 47 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_cs_fid_cl1,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 48 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_cs_fid_cl2,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 49 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor_cl1,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 50 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor_cl2,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 51 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_cs_fid_grtdo,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 52 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor_grtdo,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 53 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_cs_fid_grtdo_cl1,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 54 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor_grtdo_cl1,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 55 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_cs_fid_grtdo_cl2,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 56 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor_grtdo_cl2,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 57 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS opcao_venda,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 58 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS resgate_parcial,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 60 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS bloqueio_custodia_sdt,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 61 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantia_penhor_emissor,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 62 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor_emi_cl1,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 63 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS cesta_grt_penhor_emi_cl2,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 64 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantia_penhor_emi_2nivel,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 65 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantia_penhor_emi_cl1_2nivel,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 66 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantia_penhor_emi_cl2_2nivel,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 70 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS negociacao_termo,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 80 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS repasse_correntista,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 71 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS bloqueada_eventos,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 72 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS bloqueada_deposito,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 82 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS nao_integralizada,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 83 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS margem,
            MAX(
                CASE
                    WHEN cart.cod_tipo_posicao_carteira = 85 THEN
                        cart.qtd_carteira_participante
                    ELSE
                        0
                END
            ) AS garantia_firme
        FROM
            cetip.carteira_participante   cart
            JOIN cetip.sistema                 s ON s.num_sistema = cart.num_sistema
        WHERE
            cart.cod_tipo_posicao_carteira IN (
               82,70,59,16,1,2,3,84,42,72,85,46,83,43,69,61,19,13,4,80,71,28,33
            )
            AND cart.qtd_carteira_participante > 0
        GROUP BY
            cart.num_if,
            cart.num_conta_participante,
            cart.num_sistema,
            s.cod_sistema
			
create index CETIP.IDX01_TMP_POSICAO on CETIP.TMP_POSICAO(NUM_IF);    			
			
SELECT
    en.nom_simplificado_entidade    AS nom_simplificado_participante,
    en.nome_entidade                AS razao_social,
    stipcon.nom_st_conta            AS tipo_conta,
    tipcon.nom_tipo_conta,
    tipif.cod_tipo_if,
    if.cod_if,
    if.cod_isin,
    tpr.nom_tipo_regime_titulo,
    tit.ind_eventos_cursados_cetip,
    posicao.*,
    en2.nom_simplificado_entidade   AS nom_simplificado_emissor,
    en2.nome_entidade               AS nom_emissor,
    TO_CHAR(if.dat_emissao, 'YYYYMMDD') AS dat_emissao_if,
    (
        CASE
            WHEN fpg.num_id_grp_forma_pagamento = 16 THEN
                NULL
            ELSE
                TO_CHAR(if.dat_vencimento, 'YYYYMMDD')
        END
    ) AS dat_vencimento_if,
    TO_CHAR(cop.dat_ctl_oper, 'YYYYMMDD') AS dat_movimento,
    con2.cod_conta_participante,
    (
        CASE
            WHEN if.num_id_programa_emissao_if IS NULL THEN
                eif.nome_entidade
            ELSE
                eprg.nome_entidade
        END
    ) AS nom_agente_fiduciario,
    (
        CASE
            WHEN if.num_id_programa_emissao_if IS NULL THEN
                eif.nom_simplificado_entidade
            ELSE
                eprg.nom_simplificado_entidade
        END
    ) AS nom_simpl_agente_fiduciario,
    (
        CASE
            WHEN if.num_id_programa_emissao_if IS NULL THEN
                cif.cod_conta_participante
            ELSE
                cprg.cod_conta_participante
        END
    ) AS cod_conta_agente_fiduciario
FROM cetip.tmp_cop cop, cetip.tmp_posicao POSICAO
    JOIN cetip.conta_participante con ON con.num_conta_participante = posicao.num_conta_participante
    JOIN cetip.entidade en ON en.num_id_entidade = con.num_id_entidade
    JOIN cetip.instrumento_financeiro if ON if.num_if = posicao.num_if
    JOIN cetip.tipo_if tipif ON tipif.num_tipo_if = if.num_tipo_if
    JOIN cetip.titulo tit ON tit.num_if = if.num_if
    JOIN cetip.tipo_regime_titulo tpr ON tpr.num_id_tipo_regime_titulo = tit.num_id_tipo_regime_titulo
    JOIN cetip.conta_participante con2 ON con2.num_conta_participante = tit.num_conta_participante
    JOIN cetip.entidade en2 ON en2.num_id_entidade = con2.num_id_entidade
    JOIN cetip.tipo_conta tipcon ON tipcon.num_id_tipo_conta = con.num_id_tipo_conta
    JOIN cetip.super_tipo_conta stipcon ON stipcon.num_id_st_conta = tipcon.num_id_st_conta
    JOIN cetip.forma_pagamento fpg ON fpg.num_id_forma_pagamento = if.num_id_forma_pagamento
    LEFT JOIN cetip.conta_participante cprg ON cprg.num_conta_participante = if.num_id_programa_emissao_if
    LEFT JOIN cetip.entidade eprg ON eprg.num_id_entidade = cprg.num_id_entidade
    LEFT JOIN cetip.conta_participante cif ON cif.num_conta_participante = if.num_conta_agente_fiduciario
    LEFT JOIN cetip.entidade eif ON eif.num_id_entidade = cif.num_id_entidade
WHERE
    ( ( eprg.num_id_entidade IS NOT NULL
        AND eprg.num_id_tipo_entidade = 7 )
      OR NULL IS NULL )
    AND en.num_id_tipo_entidade = 7
    AND en2.num_id_tipo_entidade = 7
    AND ( TO_CHAR(if.dat_vencimento, 'YYYYMMDD') >= '20220105'
          OR fpg.num_id_grp_forma_pagamento = 16
          OR ( tipif.cod_tipo_if IN (
        'CSEC',
        'TDA',
        'LIG'
    ) )
          AND ( posicao.num_if IN (
        SELECT
            a.num_if
        FROM
            cetip.instrumento_financeiro a
        WHERE
            a.num_if = posicao.num_if
            AND ( a.dat_exclusao IS NULL )
    ) ) )
    AND TO_CHAR(cop.dat_ctl_oper, 'YYYYMMDD') = '20220105'
ORDER BY
    con.num_id_entidade,
    posicao.cod_sistema,
    con.num_conta_participante,
    if.cod_if,
    tipif.cod_tipo_if
    
    
    
    
    			