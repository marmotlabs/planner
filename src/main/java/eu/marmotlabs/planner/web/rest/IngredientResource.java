package eu.marmotlabs.planner.web.rest;

import com.codahale.metrics.annotation.Timed;
import eu.marmotlabs.planner.domain.Ingredient;
import eu.marmotlabs.planner.service.IngredientService;
import eu.marmotlabs.planner.web.rest.util.HeaderUtil;
import eu.marmotlabs.planner.web.rest.util.PaginationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Optional;

/**
 * REST controller for managing Ingredient.
 */
@RestController
@RequestMapping("/api")
public class IngredientResource {

    private final Logger log = LoggerFactory.getLogger(IngredientResource.class);
        
    @Inject
    private IngredientService ingredientService;
    
    /**
     * POST  /ingredients : Create a new ingredient.
     *
     * @param ingredient the ingredient to create
     * @return the ResponseEntity with status 201 (Created) and with body the new ingredient, or with status 400 (Bad Request) if the ingredient has already an ID
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @RequestMapping(value = "/ingredients",
        method = RequestMethod.POST,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Ingredient> createIngredient(@RequestBody Ingredient ingredient) throws URISyntaxException {
        log.debug("REST request to save Ingredient : {}", ingredient);
        if (ingredient.getId() != null) {
            return ResponseEntity.badRequest().headers(HeaderUtil.createFailureAlert("ingredient", "idexists", "A new ingredient cannot already have an ID")).body(null);
        }
        Ingredient result = ingredientService.save(ingredient);
        return ResponseEntity.created(new URI("/api/ingredients/" + result.getId()))
            .headers(HeaderUtil.createEntityCreationAlert("ingredient", result.getId().toString()))
            .body(result);
    }

    /**
     * PUT  /ingredients : Updates an existing ingredient.
     *
     * @param ingredient the ingredient to update
     * @return the ResponseEntity with status 200 (OK) and with body the updated ingredient,
     * or with status 400 (Bad Request) if the ingredient is not valid,
     * or with status 500 (Internal Server Error) if the ingredient couldnt be updated
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @RequestMapping(value = "/ingredients",
        method = RequestMethod.PUT,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Ingredient> updateIngredient(@RequestBody Ingredient ingredient) throws URISyntaxException {
        log.debug("REST request to update Ingredient : {}", ingredient);
        if (ingredient.getId() == null) {
            return createIngredient(ingredient);
        }
        Ingredient result = ingredientService.save(ingredient);
        return ResponseEntity.ok()
            .headers(HeaderUtil.createEntityUpdateAlert("ingredient", ingredient.getId().toString()))
            .body(result);
    }

    /**
     * GET  /ingredients : get all the ingredients.
     *
     * @param pageable the pagination information
     * @return the ResponseEntity with status 200 (OK) and the list of ingredients in body
     * @throws URISyntaxException if there is an error to generate the pagination HTTP headers
     */
    @RequestMapping(value = "/ingredients",
        method = RequestMethod.GET,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<List<Ingredient>> getAllIngredients(Pageable pageable)
        throws URISyntaxException {
        log.debug("REST request to get a page of Ingredients");
        Page<Ingredient> page = ingredientService.findAll(pageable); 
        HttpHeaders headers = PaginationUtil.generatePaginationHttpHeaders(page, "/api/ingredients");
        return new ResponseEntity<>(page.getContent(), headers, HttpStatus.OK);
    }

    /**
     * GET  /ingredients/:id : get the "id" ingredient.
     *
     * @param id the id of the ingredient to retrieve
     * @return the ResponseEntity with status 200 (OK) and with body the ingredient, or with status 404 (Not Found)
     */
    @RequestMapping(value = "/ingredients/{id}",
        method = RequestMethod.GET,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Ingredient> getIngredient(@PathVariable Long id) {
        log.debug("REST request to get Ingredient : {}", id);
        Ingredient ingredient = ingredientService.findOne(id);
        return Optional.ofNullable(ingredient)
            .map(result -> new ResponseEntity<>(
                result,
                HttpStatus.OK))
            .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    /**
     * DELETE  /ingredients/:id : delete the "id" ingredient.
     *
     * @param id the id of the ingredient to delete
     * @return the ResponseEntity with status 200 (OK)
     */
    @RequestMapping(value = "/ingredients/{id}",
        method = RequestMethod.DELETE,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Void> deleteIngredient(@PathVariable Long id) {
        log.debug("REST request to delete Ingredient : {}", id);
        ingredientService.delete(id);
        return ResponseEntity.ok().headers(HeaderUtil.createEntityDeletionAlert("ingredient", id.toString())).build();
    }

}
