package eu.marmotlabs.planner.shared.utils;

import java.util.Collection;
import java.util.stream.Stream;

/**
 * Utilities for dealing with nullable collections
 */
public class NotNull {

    /**
     * Returns a stream of the collection if it is not null or an empty stream
     */
    public static <T> Stream<T> stream(final Collection<T> value) {
        return value != null ? value.stream() : Stream.empty();
    }
}
