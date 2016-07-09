package eu.marmotlabs.planner.web.rest;

import com.codahale.metrics.annotation.Timed;
import eu.marmotlabs.planner.domain.Planner;
import eu.marmotlabs.planner.repository.PlannerRepository;
import eu.marmotlabs.planner.web.rest.util.HeaderUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import javax.validation.Valid;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Optional;

/**
 * REST controller for managing Planner.
 */
@RestController
@RequestMapping("/api")
public class PlannerResource {

    private final Logger log = LoggerFactory.getLogger(PlannerResource.class);
        
    @Inject
    private PlannerRepository plannerRepository;
    
    /**
     * POST  /planners : Create a new planner.
     *
     * @param planner the planner to create
     * @return the ResponseEntity with status 201 (Created) and with body the new planner, or with status 400 (Bad Request) if the planner has already an ID
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @RequestMapping(value = "/planners",
        method = RequestMethod.POST,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Planner> createPlanner(@Valid @RequestBody Planner planner) throws URISyntaxException {
        log.debug("REST request to save Planner : {}", planner);
        if (planner.getId() != null) {
            return ResponseEntity.badRequest().headers(HeaderUtil.createFailureAlert("planner", "idexists", "A new planner cannot already have an ID")).body(null);
        }
        Planner result = plannerRepository.save(planner);
        return ResponseEntity.created(new URI("/api/planners/" + result.getId()))
            .headers(HeaderUtil.createEntityCreationAlert("planner", result.getId().toString()))
            .body(result);
    }

    /**
     * PUT  /planners : Updates an existing planner.
     *
     * @param planner the planner to update
     * @return the ResponseEntity with status 200 (OK) and with body the updated planner,
     * or with status 400 (Bad Request) if the planner is not valid,
     * or with status 500 (Internal Server Error) if the planner couldnt be updated
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @RequestMapping(value = "/planners",
        method = RequestMethod.PUT,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Planner> updatePlanner(@Valid @RequestBody Planner planner) throws URISyntaxException {
        log.debug("REST request to update Planner : {}", planner);
        if (planner.getId() == null) {
            return createPlanner(planner);
        }
        Planner result = plannerRepository.save(planner);
        return ResponseEntity.ok()
            .headers(HeaderUtil.createEntityUpdateAlert("planner", planner.getId().toString()))
            .body(result);
    }

    /**
     * GET  /planners : get all the planners.
     *
     * @return the ResponseEntity with status 200 (OK) and the list of planners in body
     */
    @RequestMapping(value = "/planners",
        method = RequestMethod.GET,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public List<Planner> getAllPlanners() {
        log.debug("REST request to get all Planners");
        List<Planner> planners = plannerRepository.findAllWithEagerRelationships();
        return planners;
    }

    /**
     * GET  /planners/:id : get the "id" planner.
     *
     * @param id the id of the planner to retrieve
     * @return the ResponseEntity with status 200 (OK) and with body the planner, or with status 404 (Not Found)
     */
    @RequestMapping(value = "/planners/{id}",
        method = RequestMethod.GET,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Planner> getPlanner(@PathVariable Long id) {
        log.debug("REST request to get Planner : {}", id);
        Planner planner = plannerRepository.findOneWithEagerRelationships(id);
        return Optional.ofNullable(planner)
            .map(result -> new ResponseEntity<>(
                result,
                HttpStatus.OK))
            .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    /**
     * DELETE  /planners/:id : delete the "id" planner.
     *
     * @param id the id of the planner to delete
     * @return the ResponseEntity with status 200 (OK)
     */
    @RequestMapping(value = "/planners/{id}",
        method = RequestMethod.DELETE,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Void> deletePlanner(@PathVariable Long id) {
        log.debug("REST request to delete Planner : {}", id);
        plannerRepository.delete(id);
        return ResponseEntity.ok().headers(HeaderUtil.createEntityDeletionAlert("planner", id.toString())).build();
    }

}
