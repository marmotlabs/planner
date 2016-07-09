package eu.marmotlabs.planner.repository;

import eu.marmotlabs.planner.domain.Planner;

import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * Spring Data JPA repository for the Planner entity.
 */
@SuppressWarnings("unused")
public interface PlannerRepository extends JpaRepository<Planner,Long> {

    @Query("select planner from Planner planner where planner.user.login = ?#{principal.username}")
    List<Planner> findByUserIsCurrentUser();

    @Query("select distinct planner from Planner planner left join fetch planner.recipes")
    List<Planner> findAllWithEagerRelationships();

    @Query("select planner from Planner planner left join fetch planner.recipes where planner.id =:id")
    Planner findOneWithEagerRelationships(@Param("id") Long id);

}
