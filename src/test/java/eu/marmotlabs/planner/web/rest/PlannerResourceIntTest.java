package eu.marmotlabs.planner.web.rest;

import eu.marmotlabs.planner.PlannerApp;
import eu.marmotlabs.planner.domain.Planner;
import eu.marmotlabs.planner.repository.PlannerRepository;
import eu.marmotlabs.planner.service.PlannerService;

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
import java.time.Instant;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.ZoneId;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


/**
 * Test class for the PlannerResource REST controller.
 *
 * @see PlannerResource
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = PlannerApp.class)
@WebAppConfiguration
@IntegrationTest
public class PlannerResourceIntTest {

    private static final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").withZone(ZoneId.of("Z"));

    private static final String DEFAULT_NAME = "AAAAA";
    private static final String UPDATED_NAME = "BBBBB";

    private static final ZonedDateTime DEFAULT_DATE = ZonedDateTime.ofInstant(Instant.ofEpochMilli(0L), ZoneId.systemDefault());
    private static final ZonedDateTime UPDATED_DATE = ZonedDateTime.now(ZoneId.systemDefault()).withNano(0);
    private static final String DEFAULT_DATE_STR = dateTimeFormatter.format(DEFAULT_DATE);

    @Inject
    private PlannerRepository plannerRepository;

    @Inject
    private PlannerService plannerService;

    @Inject
    private MappingJackson2HttpMessageConverter jacksonMessageConverter;

    @Inject
    private PageableHandlerMethodArgumentResolver pageableArgumentResolver;

    private MockMvc restPlannerMockMvc;

    private Planner planner;

    @PostConstruct
    public void setup() {
        MockitoAnnotations.initMocks(this);
        PlannerResource plannerResource = new PlannerResource();
        ReflectionTestUtils.setField(plannerResource, "plannerService", plannerService);
        this.restPlannerMockMvc = MockMvcBuilders.standaloneSetup(plannerResource)
            .setCustomArgumentResolvers(pageableArgumentResolver)
            .setMessageConverters(jacksonMessageConverter).build();
    }

    @Before
    public void initTest() {
        planner = new Planner();
        planner.setName(DEFAULT_NAME);
        planner.setDate(DEFAULT_DATE);
    }

    @Test
    @Transactional
    public void createPlanner() throws Exception {
        int databaseSizeBeforeCreate = plannerRepository.findAll().size();

        // Create the Planner

        restPlannerMockMvc.perform(post("/api/planners")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(planner)))
                .andExpect(status().isCreated());

        // Validate the Planner in the database
        List<Planner> planners = plannerRepository.findAll();
        assertThat(planners).hasSize(databaseSizeBeforeCreate + 1);
        Planner testPlanner = planners.get(planners.size() - 1);
        assertThat(testPlanner.getName()).isEqualTo(DEFAULT_NAME);
        assertThat(testPlanner.getDate()).isEqualTo(DEFAULT_DATE);
    }

    @Test
    @Transactional
    public void checkNameIsRequired() throws Exception {
        int databaseSizeBeforeTest = plannerRepository.findAll().size();
        // set the field null
        planner.setName(null);

        // Create the Planner, which fails.

        restPlannerMockMvc.perform(post("/api/planners")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(planner)))
                .andExpect(status().isBadRequest());

        List<Planner> planners = plannerRepository.findAll();
        assertThat(planners).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkDateIsRequired() throws Exception {
        int databaseSizeBeforeTest = plannerRepository.findAll().size();
        // set the field null
        planner.setDate(null);

        // Create the Planner, which fails.

        restPlannerMockMvc.perform(post("/api/planners")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(planner)))
                .andExpect(status().isBadRequest());

        List<Planner> planners = plannerRepository.findAll();
        assertThat(planners).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void getAllPlanners() throws Exception {
        // Initialize the database
        plannerRepository.saveAndFlush(planner);

        // Get all the planners
        restPlannerMockMvc.perform(get("/api/planners?sort=id,desc"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.[*].id").value(hasItem(planner.getId().intValue())))
                .andExpect(jsonPath("$.[*].name").value(hasItem(DEFAULT_NAME.toString())))
                .andExpect(jsonPath("$.[*].date").value(hasItem(DEFAULT_DATE_STR)));
    }

    @Test
    @Transactional
    public void getPlanner() throws Exception {
        // Initialize the database
        plannerRepository.saveAndFlush(planner);

        // Get the planner
        restPlannerMockMvc.perform(get("/api/planners/{id}", planner.getId()))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(jsonPath("$.id").value(planner.getId().intValue()))
            .andExpect(jsonPath("$.name").value(DEFAULT_NAME.toString()))
            .andExpect(jsonPath("$.date").value(DEFAULT_DATE_STR));
    }

    @Test
    @Transactional
    public void getNonExistingPlanner() throws Exception {
        // Get the planner
        restPlannerMockMvc.perform(get("/api/planners/{id}", Long.MAX_VALUE))
                .andExpect(status().isNotFound());
    }

    @Test
    @Transactional
    public void updatePlanner() throws Exception {
        // Initialize the database
        plannerService.save(planner);

        int databaseSizeBeforeUpdate = plannerRepository.findAll().size();

        // Update the planner
        Planner updatedPlanner = new Planner();
        updatedPlanner.setId(planner.getId());
        updatedPlanner.setName(UPDATED_NAME);
        updatedPlanner.setDate(UPDATED_DATE);

        restPlannerMockMvc.perform(put("/api/planners")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(updatedPlanner)))
                .andExpect(status().isOk());

        // Validate the Planner in the database
        List<Planner> planners = plannerRepository.findAll();
        assertThat(planners).hasSize(databaseSizeBeforeUpdate);
        Planner testPlanner = planners.get(planners.size() - 1);
        assertThat(testPlanner.getName()).isEqualTo(UPDATED_NAME);
        assertThat(testPlanner.getDate()).isEqualTo(UPDATED_DATE);
    }

    @Test
    @Transactional
    public void deletePlanner() throws Exception {
        // Initialize the database
        plannerService.save(planner);

        int databaseSizeBeforeDelete = plannerRepository.findAll().size();

        // Get the planner
        restPlannerMockMvc.perform(delete("/api/planners/{id}", planner.getId())
                .accept(TestUtil.APPLICATION_JSON_UTF8))
                .andExpect(status().isOk());

        // Validate the database is empty
        List<Planner> planners = plannerRepository.findAll();
        assertThat(planners).hasSize(databaseSizeBeforeDelete - 1);
    }
}
