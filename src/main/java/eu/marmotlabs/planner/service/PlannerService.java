package eu.marmotlabs.planner.service;

import eu.marmotlabs.planner.domain.Planner;
import eu.marmotlabs.planner.repository.PlannerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.List;

/**
 * Service Implementation for managing Planner.
 */
@Service
@Transactional
public class PlannerService {

    private final Logger log = LoggerFactory.getLogger(PlannerService.class);
    
    @Inject
    private PlannerRepository plannerRepository;
    
    /**
     * Save a planner.
     * 
     * @param planner the entity to save
     * @return the persisted entity
     */
    public Planner save(Planner planner) {
        log.debug("Request to save Planner : {}", planner);
        Planner result = plannerRepository.save(planner);
        return result;
    }

    /**
     *  Get all the planners.
     *  
     *  @param pageable the pagination information
     *  @return the list of entities
     */
    @Transactional(readOnly = true) 
    public Page<Planner> findAll(Pageable pageable) {
        log.debug("Request to get all Planners");
        Page<Planner> result = plannerRepository.findAll(pageable); 
        return result;
    }

    /**
     *  Get one planner by id.
     *
     *  @param id the id of the entity
     *  @return the entity
     */
    @Transactional(readOnly = true) 
    public Planner findOne(Long id) {
        log.debug("Request to get Planner : {}", id);
        Planner planner = plannerRepository.findOneWithEagerRelationships(id);
        return planner;
    }

    /**
     *  Delete the  planner by id.
     *  
     *  @param id the id of the entity
     */
    public void delete(Long id) {
        log.debug("Request to delete Planner : {}", id);
        plannerRepository.delete(id);
    }
}
