package eu.marmotlabs.planner.startup;

import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

@Component
public class StartupListener implements ApplicationListener<ContextRefreshedEvent> {

    @Override
    public void onApplicationEvent(final ContextRefreshedEvent event) {

    }
}
