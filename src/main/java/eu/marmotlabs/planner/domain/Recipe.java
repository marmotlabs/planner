package eu.marmotlabs.planner.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import javax.validation.constraints.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
import java.util.Objects;

import eu.marmotlabs.planner.domain.enumeration.Category;

/**
 * A Recipe.
 */
@Entity
@Table(name = "recipe")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class Recipe implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull
    @Column(name = "title", nullable = false)
    private String title;

    @NotNull
    @Column(name = "description", nullable = false)
    private String description;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "category", nullable = false)
    private Category category;

    @Column(name = "active_required_time")
    private Integer activeRequiredTime;

    @Column(name = "picture")
    private String picture;

    @NotNull
    @Column(name = "portions", nullable = false)
    private Integer portions;

    @ManyToMany
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @JoinTable(name = "recipe_ingredient",
               joinColumns = @JoinColumn(name="recipes_id", referencedColumnName="ID"),
               inverseJoinColumns = @JoinColumn(name="ingredients_id", referencedColumnName="ID"))
    private Set<Ingredient> ingredients = new HashSet<>();

    @ManyToMany(mappedBy = "recipes")
    @JsonIgnore
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    private Set<Planner> planners = new HashSet<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Integer getActiveRequiredTime() {
        return activeRequiredTime;
    }

    public void setActiveRequiredTime(Integer activeRequiredTime) {
        this.activeRequiredTime = activeRequiredTime;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public Integer getPortions() {
        return portions;
    }

    public void setPortions(Integer portions) {
        this.portions = portions;
    }

    public Set<Ingredient> getIngredients() {
        return ingredients;
    }

    public void setIngredients(Set<Ingredient> ingredients) {
        this.ingredients = ingredients;
    }

    public Set<Planner> getPlanners() {
        return planners;
    }

    public void setPlanners(Set<Planner> planners) {
        this.planners = planners;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Recipe recipe = (Recipe) o;
        if(recipe.id == null || id == null) {
            return false;
        }
        return Objects.equals(id, recipe.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }

    @Override
    public String toString() {
        return "Recipe{" +
            "id=" + id +
            ", title='" + title + "'" +
            ", description='" + description + "'" +
            ", category='" + category + "'" +
            ", activeRequiredTime='" + activeRequiredTime + "'" +
            ", picture='" + picture + "'" +
            ", portions='" + portions + "'" +
            '}';
    }
}
