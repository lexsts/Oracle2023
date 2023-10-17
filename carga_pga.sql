create table CETIP.TMP_CARGA_20221222
AS
SELECT /*+ PARALLEL(64) */
           sq.nom_malote,
           sq.sig_uf,
           sq.cod_conta_participante,
           sq.nom_conta_participante,
           cs.txt_tipo_pessoa,
           cs.cod_documento,
           cs.nome_comitente,
           sq.cod_sistema,
           sq.cod_tipo_if,
           sq.cod_if,
           sq.cod_isin,
           sq.nom_tipo_posicao_carteira,
           sq.qtd_carteira_comitente,
           cs.num_id_situacao_comitente,
           cs.cod_conta_participante    cs_cod_conta_participante,
           cs.cod_conta_individualizada,
           RPAD(NVL(t.NUM_CONTROLE_INTERNO_PARTIC, ' '), 10, ' ') num_controle_interno_partic,
           trt.nom_tipo_regime_titulo,
           DECODE(t.ind_eventos_cursados_cetip, 'S', 'SIM', 'N', 'N?O', '   ') ind_eventos_cursados_cetip,
		   NVL(t.ind_vencido_inadimplido, 'N') ind_vencido_inadimplido           
      FROM (SELECT cc.num_id_entidade,
                   cc.num_if,
                   mal.nom_malote,
                   mal.sig_uf,
                   cpa.cod_conta_participante,
                   cc.num_conta_participante,
                   cpa.nom_conta_participante,
                   if_sistema.cod_sistema,
                   if_sistema.cod_tipo_if,
                   if_sistema.cod_if,
                   if_sistema.cod_isin,
                   tpc.nom_tipo_posicao_carteira,
                   cc.qtd_carteira_comitente
              FROM cetip.carteira_comitente cc,
                   cetip.conta_participante cpa,
                   (SELECT f.num_if, f.num_sistema, si.cod_sistema, f.cod_isin, f.cod_if, tif.cod_tipo_if
                      FROM cetip.instrumento_financeiro f, cetip.tipo_if tif, cetip.sistema si
                     WHERE f.num_tipo_if = tif.num_tipo_if
                       AND f.num_sistema = si.num_sistema
                       AND f.dat_exclusao IS NULL) if_sistema,
                   (SELECT cod_tipo_posicao_carteira, nom_tipo_posicao_carteira
                      FROM cetip.tipo_posicao_carteira
                     WHERE cod_tipo_posicao_carteira IN (46, 1, 2, 4, 8, 19, 80, 72, 83, 84, 82)) tpc,
                   (SELECT m.num_id_malote, m.nom_malote, uf.sig_uf
                      FROM cetip.malote m, cetip.uf uf
                     WHERE m.num_id_uf = uf.num_id_uf) mal
             WHERE cc.num_if = if_sistema.num_if
               AND cc.cod_tipo_posicao_carteira = tpc.cod_tipo_posicao_carteira
               AND cpa.num_conta_participante = cc.num_conta_participante
               AND cpa.num_id_malote = mal.num_id_malote
               AND cc.qtd_carteira_comitente > 0
         AND mal.nom_malote not in ('00010', '04856', '19352', '70080', '70410', '72370', '73410')
               ) sq,
           -- Substitui CETIP.V_COMITENTES_SIMPL
           (SELECT rel.num_id_entidade_para num_id_comitente,
                   c.num_id_situacao_comitente,
                   (CASE
                     WHEN pf.cod_cpf IS NULL THEN
                      decode(rel.num_id_tipo_relacao, 57, 'JURIDICA', 92, 'SEM_PERSONALIDADE_JURIDICA')
                     ELSE
                      'FISICA'
                   END) txt_tipo_pessoa,
                   (CASE
                     WHEN pf.cod_cpf IS NULL THEN
                      pj.cod_nacional_pj
                     ELSE
                      pf.cod_cpf
                   END) cod_documento,
                   e.nome_entidade nome_comitente,
                   cpart.cod_conta_participante,
                   ccom.cod_conta_deposito cod_conta_individualizada
              FROM cetip.entidade e,
                   cetip.comitente c,
                   (SELECT * FROM cetip.pessoa_fisica WHERE cod_cpf IS NOT NULL) pf,
                   (SELECT * FROM cetip.pessoa_juridica WHERE cod_nacional_pj IS NOT NULL) pj,
                   cetip.conta_comitente ccom,
                   (SELECT *
                      FROM cetip.relacao
                     WHERE num_id_tipo_relacao IN (56, 57, 92)
                       AND ind_excluido = 'N') rel,
                   cetip.conta_participante cpart
             WHERE e.num_id_entidade = rel.num_id_entidade
               AND pf.num_id_entidade(+) = rel.num_id_entidade
               AND pj.num_id_entidade(+) = rel.num_id_entidade
               AND ccom.num_id_entidade = c.num_id_entidade
               AND rel.num_id_entidade_para = ccom.num_id_entidade
               AND ccom.num_conta_participante = cpart.num_conta_participante) cs,
               cetip.titulo t,
               cetip.tipo_regime_titulo trt
     WHERE sq.num_id_entidade = cs.num_id_comitente and
           t.num_if = sq.num_if and
           trt.num_id_tipo_regime_titulo = t.num_id_tipo_regime_titulo
     ORDER BY sq.nom_malote, sq.num_conta_participante, sq.sig_uf, sq.cod_conta_participante;