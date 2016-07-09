package eu.marmotlabs.planner.service;

import eu.marmotlabs.planner.domain.Recipe;
import eu.marmotlabs.planner.repository.RecipeRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.List;

/**
 * Service Implementation for managing Recipe.
 */
@Service
@Transactional
public class RecipeService {

    private final Logger log = LoggerFactory.getLogger(RecipeService.class);
    
    @Inject
    private RecipeRepository recipeRepository;
    
    /**
     * Save a recipe.
     * 
     * @param recipe the entity to save
     * @return the persisted entity
     */
    public Recipe save(Recipe recipe) {
        log.debug("Request to save Recipe : {}", recipe);
        Recipe result = recipeRepository.save(recipe);
        return result;
    }

    /**
     *  Get all the recipes.
     *  
     *  @param pageable the pagination information
     *  @return the list of entities
     */
    @Transactional(readOnly = true) 
    public Page<Recipe> findAll(Pageable pageable) {
        log.debug("Request to get all Recipes");
        Page<Recipe> result = recipeRepository.findAll(pageable); 
        return result;
    }

    /**
     *  Get one recipe by id.
     *
     *  @param id the id of the entity
     *  @return the entity
     */
    @Transactional(readOnly = true) 
    public Recipe findOne(Long id) {
        log.debug("Request to get Recipe : {}", id);
        Recipe recipe = recipeRepository.findOneWithEagerRelationships(id);
        return recipe;
    }

    /**
     *  Delete the  recipe by id.
     *  
     *  @param id the id of the entity
     */
    public void delete(Long id) {
        log.debug("Request to delete Recipe : {}", id);
        recipeRepository.delete(id);
    }
}
