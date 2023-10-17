SELECT substr(DECODE(request,0,'Bloqueador: ','Bloqueado: ')||sid,1,20) sessao,
       --id1, id2, lmode, request, type,
       inst_id instance
 FROM GV$LOCK
WHERE (id1, id2, type) IN
   (SELECT id1, id2, type FROM GV$LOCK WHERE request>0)
     ORDER BY id1, request;
