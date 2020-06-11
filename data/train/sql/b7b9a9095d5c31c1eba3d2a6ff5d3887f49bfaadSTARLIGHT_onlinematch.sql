SELECT a.Objid, a.plate, a.mjd, a.fiberid, a.ra, a.dec, a.modelMag_u, a.modelMag_g, a.modelMag_r, a.modelMag_i, a.modelMag_z, a.fuv_mag, a.nuv_mag, a.dered_u, a.dered_g, a.dered_r, a.dered_r, a.dered_z, a.petroR90_r, a.fuv_magerr, a.nuv_magerr, a.e_bv, a.s2n_r, a.sn_fuv_auto, a.redshift, a.redshift_err, a.survey, b.A_V, b.Dn4000_synth, b.Dn4000_obs, a.type
INTO MyDB.results_2014_11_21_b
FROM MyDB.SDSS_results_bigger_r90 as a, MyDB.new_data as b
WHERE (a.plate = b.plate) AND (a.mjd = b.mjd) AND (a.fiberid = b.fiberid)
ORDER BY a.plate, a.mjd, a.fiberid, a.Objid
