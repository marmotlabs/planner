package eu.marmotlabs.planner.repository;

import eu.marmotlabs.planner.domain.Ingredient;

import org.springframework.data.jpa.repository.*;

import java.util.List;

/**
 * Spring Data JPA repository for the Ingredient entity.
 */
@SuppressWarnings("unused")
public interface IngredientRepository extends JpaRepository<Ingredient,Long> {

}
