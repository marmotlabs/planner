package eu.marmotlabs.planner.web.rest;

import eu.marmotlabs.planner.PlannerApp;
import eu.marmotlabs.planner.domain.Recipe;
import eu.marmotlabs.planner.repository.RecipeRepository;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import static org.hamcrest.Matchers.hasItem;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import eu.marmotlabs.planner.domain.enumeration.Category;

/**
 * Test class for the RecipeResource REST controller.
 *
 * @see RecipeResource
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = PlannerApp.class)
@WebAppConfiguration
@IntegrationTest
public class RecipeResourceIntTest {

    private static final String DEFAULT_TITLE = "AAAAA";
    private static final String UPDATED_TITLE = "BBBBB";
    private static final String DEFAULT_DESCRIPTION = "AAAAA";
    private static final String UPDATED_DESCRIPTION = "BBBBB";

    private static final Category DEFAULT_CATEGORY = Category.VEGAN;
    private static final Category UPDATED_CATEGORY = Category.RAW_VEGAN;

    private static final Integer DEFAULT_ACTIVE_REQUIRED_TIME = 1;
    private static final Integer UPDATED_ACTIVE_REQUIRED_TIME = 2;
    private static final String DEFAULT_PICTURE = "AAAAA";
    private static final String UPDATED_PICTURE = "BBBBB";

    private static final Integer DEFAULT_PORTIONS = 1;
    private static final Integer UPDATED_PORTIONS = 2;

    @Inject
    private RecipeRepository recipeRepository;

    @Inject
    private MappingJackson2HttpMessageConverter jacksonMessageConverter;

    @Inject
    private PageableHandlerMethodArgumentResolver pageableArgumentResolver;

    private MockMvc restRecipeMockMvc;

    private Recipe recipe;

    @PostConstruct
    public void setup() {
        MockitoAnnotations.initMocks(this);
        RecipeResource recipeResource = new RecipeResource();
        ReflectionTestUtils.setField(recipeResource, "recipeRepository", recipeRepository);
        this.restRecipeMockMvc = MockMvcBuilders.standaloneSetup(recipeResource)
            .setCustomArgumentResolvers(pageableArgumentResolver)
            .setMessageConverters(jacksonMessageConverter).build();
    }

    @Before
    public void initTest() {
        recipe = new Recipe();
        recipe.setTitle(DEFAULT_TITLE);
        recipe.setDescription(DEFAULT_DESCRIPTION);
        recipe.setCategory(DEFAULT_CATEGORY);
        recipe.setActiveRequiredTime(DEFAULT_ACTIVE_REQUIRED_TIME);
        recipe.setPicture(DEFAULT_PICTURE);
        recipe.setPortions(DEFAULT_PORTIONS);
    }

    @Test
    @Transactional
    public void createRecipe() throws Exception {
        int databaseSizeBeforeCreate = recipeRepository.findAll().size();

        // Create the Recipe

        restRecipeMockMvc.perform(post("/api/recipes")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(recipe)))
                .andExpect(status().isCreated());

        // Validate the Recipe in the database
        List<Recipe> recipes = recipeRepository.findAll();
        assertThat(recipes).hasSize(databaseSizeBeforeCreate + 1);
        Recipe testRecipe = recipes.get(recipes.size() - 1);
        assertThat(testRecipe.getTitle()).isEqualTo(DEFAULT_TITLE);
        assertThat(testRecipe.getDescription()).isEqualTo(DEFAULT_DESCRIPTION);
        assertThat(testRecipe.getCategory()).isEqualTo(DEFAULT_CATEGORY);
        assertThat(testRecipe.getActiveRequiredTime()).isEqualTo(DEFAULT_ACTIVE_REQUIRED_TIME);
        assertThat(testRecipe.getPicture()).isEqualTo(DEFAULT_PICTURE);
        assertThat(testRecipe.getPortions()).isEqualTo(DEFAULT_PORTIONS);
    }

    @Test
    @Transactional
    public void checkTitleIsRequired() throws Exception {
        int databaseSizeBeforeTest = recipeRepository.findAll().size();
        // set the field null
        recipe.setTitle(null);

        // Create the Recipe, which fails.

        restRecipeMockMvc.perform(post("/api/recipes")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(recipe)))
                .andExpect(status().isBadRequest());

        List<Recipe> recipes = recipeRepository.findAll();
        assertThat(recipes).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkDescriptionIsRequired() throws Exception {
        int databaseSizeBeforeTest = recipeRepository.findAll().size();
        // set the field null
        recipe.setDescription(null);

        // Create the Recipe, which fails.

        restRecipeMockMvc.perform(post("/api/recipes")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(recipe)))
                .andExpect(status().isBadRequest());

        List<Recipe> recipes = recipeRepository.findAll();
        assertThat(recipes).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkCategoryIsRequired() throws Exception {
        int databaseSizeBeforeTest = recipeRepository.findAll().size();
        // set the field null
        recipe.setCategory(null);

        // Create the Recipe, which fails.

        restRecipeMockMvc.perform(post("/api/recipes")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(recipe)))
                .andExpect(status().isBadRequest());

        List<Recipe> recipes = recipeRepository.findAll();
        assertThat(recipes).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkPortionsIsRequired() throws Exception {
        int databaseSizeBeforeTest = recipeRepository.findAll().size();
        // set the field null
        recipe.setPortions(null);

        // Create the Recipe, which fails.

        restRecipeMockMvc.perform(post("/api/recipes")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(recipe)))
                .andExpect(status().isBadRequest());

        List<Recipe> recipes = recipeRepository.findAll();
        assertThat(recipes).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void getAllRecipes() throws Exception {
        // Initialize the database
        recipeRepository.saveAndFlush(recipe);

        // Get all the recipes
        restRecipeMockMvc.perform(get("/api/recipes?sort=id,desc"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.[*].id").value(hasItem(recipe.getId().intValue())))
                .andExpect(jsonPath("$.[*].title").value(hasItem(DEFAULT_TITLE.toString())))
                .andExpect(jsonPath("$.[*].description").value(hasItem(DEFAULT_DESCRIPTION.toString())))
                .andExpect(jsonPath("$.[*].category").value(hasItem(DEFAULT_CATEGORY.toString())))
                .andExpect(jsonPath("$.[*].activeRequiredTime").value(hasItem(DEFAULT_ACTIVE_REQUIRED_TIME)))
                .andExpect(jsonPath("$.[*].picture").value(hasItem(DEFAULT_PICTURE.toString())))
                .andExpect(jsonPath("$.[*].portions").value(hasItem(DEFAULT_PORTIONS)));
    }

    @Test
    @Transactional
    public void getRecipe() throws Exception {
        // Initialize the database
        recipeRepository.saveAndFlush(recipe);

        // Get the recipe
        restRecipeMockMvc.perform(get("/api/recipes/{id}", recipe.getId()))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(jsonPath("$.id").value(recipe.getId().intValue()))
            .andExpect(jsonPath("$.title").value(DEFAULT_TITLE.toString()))
            .andExpect(jsonPath("$.description").value(DEFAULT_DESCRIPTION.toString()))
            .andExpect(jsonPath("$.category").value(DEFAULT_CATEGORY.toString()))
            .andExpect(jsonPath("$.activeRequiredTime").value(DEFAULT_ACTIVE_REQUIRED_TIME))
            .andExpect(jsonPath("$.picture").value(DEFAULT_PICTURE.toString()))
            .andExpect(jsonPath("$.portions").value(DEFAULT_PORTIONS));
    }

    @Test
    @Transactional
    public void getNonExistingRecipe() throws Exception {
        // Get the recipe
        restRecipeMockMvc.perform(get("/api/recipes/{id}", Long.MAX_VALUE))
                .andExpect(status().isNotFound());
    }

    @Test
    @Transactional
    public void updateRecipe() throws Exception {
        // Initialize the database
        recipeRepository.saveAndFlush(recipe);
        int databaseSizeBeforeUpdate = recipeRepository.findAll().size();

        // Update the recipe
        Recipe updatedRecipe = new Recipe();
        updatedRecipe.setId(recipe.getId());
        updatedRecipe.setTitle(UPDATED_TITLE);
        updatedRecipe.setDescription(UPDATED_DESCRIPTION);
        updatedRecipe.setCategory(UPDATED_CATEGORY);
        updatedRecipe.setActiveRequiredTime(UPDATED_ACTIVE_REQUIRED_TIME);
        updatedRecipe.setPicture(UPDATED_PICTURE);
        updatedRecipe.setPortions(UPDATED_PORTIONS);

        restRecipeMockMvc.perform(put("/api/recipes")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(updatedRecipe)))
                .andExpect(status().isOk());

        // Validate the Recipe in the database
        List<Recipe> recipes = recipeRepository.findAll();
        assertThat(recipes).hasSize(databaseSizeBeforeUpdate);
        Recipe testRecipe = recipes.get(recipes.size() - 1);
        assertThat(testRecipe.getTitle()).isEqualTo(UPDATED_TITLE);
        assertThat(testRecipe.getDescription()).isEqualTo(UPDATED_DESCRIPTION);
        assertThat(testRecipe.getCategory()).isEqualTo(UPDATED_CATEGORY);
        assertThat(testRecipe.getActiveRequiredTime()).isEqualTo(UPDATED_ACTIVE_REQUIRED_TIME);
        assertThat(testRecipe.getPicture()).isEqualTo(UPDATED_PICTURE);
        assertThat(testRecipe.getPortions()).isEqualTo(UPDATED_PORTIONS);
    }

    @Test
    @Transactional
    public void deleteRecipe() throws Exception {
        // Initialize the database
        recipeRepository.saveAndFlush(recipe);
        int databaseSizeBeforeDelete = recipeRepository.findAll().size();

        // Get the recipe
        restRecipeMockMvc.perform(delete("/api/recipes/{id}", recipe.getId())
                .accept(TestUtil.APPLICATION_JSON_UTF8))
                .andExpect(status().isOk());

        // Validate the database is empty
        List<Recipe> recipes = recipeRepository.findAll();
        assertThat(recipes).hasSize(databaseSizeBeforeDelete - 1);
    }
}
