/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package be.ugent.maf.cellmissy.repository.impl;

import be.ugent.maf.cellmissy.entity.Magnification;
import be.ugent.maf.cellmissy.repository.MagnificationRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Paola Masuzzo
 */
@Repository("magnificationRepository")
class MagnificationJpaRepository extends GenericJpaRepository<Magnification, Long> implements MagnificationRepository{
    
}
