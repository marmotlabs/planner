package eu.marmotlabs.planner.service;

import eu.marmotlabs.planner.domain.Ingredient;
import eu.marmotlabs.planner.repository.IngredientRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.List;

/**
 * Service Implementation for managing Ingredient.
 */
@Service
@Transactional
public class IngredientService {

    private final Logger log = LoggerFactory.getLogger(IngredientService.class);
    
    @Inject
    private IngredientRepository ingredientRepository;
    
    /**
     * Save a ingredient.
     * 
     * @param ingredient the entity to save
     * @return the persisted entity
     */
    public Ingredient save(Ingredient ingredient) {
        log.debug("Request to save Ingredient : {}", ingredient);
        Ingredient result = ingredientRepository.save(ingredient);
        return result;
    }

    /**
     *  Get all the ingredients.
     *  
     *  @param pageable the pagination information
     *  @return the list of entities
     */
    @Transactional(readOnly = true) 
    public Page<Ingredient> findAll(Pageable pageable) {
        log.debug("Request to get all Ingredients");
        Page<Ingredient> result = ingredientRepository.findAll(pageable); 
        return result;
    }

    /**
     *  Get one ingredient by id.
     *
     *  @param id the id of the entity
     *  @return the entity
     */
    @Transactional(readOnly = true) 
    public Ingredient findOne(Long id) {
        log.debug("Request to get Ingredient : {}", id);
        Ingredient ingredient = ingredientRepository.findOne(id);
        return ingredient;
    }

    /**
     *  Delete the  ingredient by id.
     *  
     *  @param id the id of the entity
     */
    public void delete(Long id) {
        log.debug("Request to delete Ingredient : {}", id);
        ingredientRepository.delete(id);
    }
}
