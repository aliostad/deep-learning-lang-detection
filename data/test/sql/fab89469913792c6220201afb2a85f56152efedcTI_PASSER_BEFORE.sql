--------------------------------------------------------
--  DDL for Trigger TI_PASSER_BEFORE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "G11_FLIGHT"."TI_PASSER_BEFORE" 
BEFORE INSERT ON passer
FOR EACH ROW
DECLARE
  v_cat_num categorie.cat_num%TYPE;
  v_maillot_couleur categorie.maillot_couleur%TYPE;
  v_bareme_pts bareme.bareme_pts%TYPE;
  v_part_tps_gene participant.part_tps_gene%TYPE;
  v_part_num participant.part_num%TYPE;
  inconstitency_passer EXCEPTION;
BEGIN
	SELECT COUNT(*) INTO :new.pass_class FROM passer WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND pt_pass_num = :new.pt_pass_num;
	:new.pass_class := :new.pass_class + 1;
	
	--On doit vérifier deux cohérences:
		-- Le participant est passé au point de passage précédent (ou à fini l'étape précédente si premier point de passage
		-- Le temps est supérieur ou égal au temps du précédent point de passage
	BEGIN
		IF :new.pt_pass_num > 1 THEN
				SELECT part_num INTO v_part_num FROM passer WHERE tour_annee =:new.tour_annee AND etape_num = :new.etape_num 
				AND pt_pass_num = :new.pt_pass_num - 1 AND part_num = :new.part_num AND pass_tps <= :new.pass_tps;
		ELSIF :new.etape_num  > 1 THEN
				SELECT part_num INTO v_part_num FROM terminer_etape WHERE tour_annee =:new.tour_annee AND etape_num = :new.etape_num - 1 AND part_num = :new.part_num
				AND pt_pass_num = (
					SELECT MAX(pt_pass_num) FROM point_passage WHERE tour_annee = :new.tour_annee AND etape_num =:new.etape_num - 1
        );
		END IF;
	EXCEPTION
		WHEN no_data_found THEN raise inconstitency_passer;
	END;
	
	SELECT part_tps_gene INTO v_part_tps_gene FROM participant WHERE tour_annee = :new.tour_annee AND part_num = :new.part_num;
  
  --On récupere la catégorie du point de passage
  SELECT p.cat_num INTO v_cat_num FROM point_passage p WHERE p.tour_annee = :new.tour_annee AND p.etape_num = :new.etape_num AND p.pt_pass_num = :new.pt_pass_num;
  
  IF :new.pt_pass_num = 1 THEN
    INSERT INTO terminer_etape (tour_annee, part_num, etape_num, etape_class, etape_tps, etape_pts_mont, etape_pts_sprint, pt_pass_num)
    VALUES (:new.tour_annee, :new.part_num, :new.etape_num, :new.pass_class, :new.pass_tps, 0, 0, :new.pt_pass_num);
  ELSE
    UPDATE terminer_etape SET etape_class = :new.pass_class, etape_tps = :new.pass_tps, gene_tps = v_part_tps_gene + :new.pass_tps, pt_pass_num = :new.pt_pass_num
    WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND part_num = :new.part_num;
  END IF;

  --On récupère les points et la couleur du maillot pour mettre à jour terminer etape
  IF v_cat_num IS NOT NULL THEN
    BEGIN
      SELECT c.maillot_couleur, b.bareme_pts 
      INTO v_maillot_couleur ,v_bareme_pts
      FROM categorie c inner join bareme b ON c.cat_num = b.cat_num
      WHERE c.cat_num = v_cat_num AND b.bareme_place = :new.pass_class;
    EXCEPTION
      WHEN no_data_found THEN 
        v_maillot_couleur := NULL;
    END;
      
    IF v_maillot_couleur = 'pois' THEN
      UPDATE TERMINER_ETAPE SET etape_pts_mont = etape_pts_mont + v_bareme_pts, gene_pts_mont = gene_pts_mont + v_bareme_pts
      WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND part_num = :new.part_num;
    ELSIF v_maillot_couleur = 'vert' THEN
      UPDATE TERMINER_ETAPE SET etape_pts_sprint = etape_pts_sprint + v_bareme_pts, gene_pts_sprint = gene_pts_sprint + v_bareme_pts
      WHERE tour_annee = :new.tour_annee AND etape_num = :new.etape_num AND part_num = :new.part_num;
    END IF;
  END IF;
EXCEPTION
	WHEN no_data_found THEN dbms_output.put_line('Fatal error');
	WHEN inconstitency_passer THEN 
    dbms_output.put_line('Problème d''incohérence: vérifier que le coureur a passer les points de passage précédents et/ou que le temps est supérieur');
    raise inconstitency_passer;
END ti_passer_before;
/
ALTER TRIGGER "G11_FLIGHT"."TI_PASSER_BEFORE" ENABLE;
