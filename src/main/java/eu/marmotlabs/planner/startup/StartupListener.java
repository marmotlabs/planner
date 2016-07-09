package eu.marmotlabs.planner.startup;

import eu.marmotlabs.planner.domain.Product;
import eu.marmotlabs.planner.domain.enumeration.UnitOfMeasure;
import eu.marmotlabs.planner.service.ProductService;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import javax.inject.Inject;

@Component
public class StartupListener implements ApplicationListener<ContextRefreshedEvent> {

    @Inject
    ProductService productService;

    @Override
    public void onApplicationEvent(final ContextRefreshedEvent event) {
        Product milk = new Product();

        milk.setName("Milk");
        milk.setUnitOfMeasure(UnitOfMeasure.ML);

        productService.save(milk);
    }
}
