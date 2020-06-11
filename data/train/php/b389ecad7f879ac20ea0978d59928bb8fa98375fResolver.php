<?php namespace Ilya\Resolver;

use Illuminate\Support\Str;
use Illuminate\Foundation\AliasLoader;

class Resolver {

    /**
     * Resolve all facades that match the query string
     *
     * @param string $query
     * @return array
     */
    public function resolve($query)
    {
        $aliases = $this->filter($this->getAliases(), $query);

        $data = [];

        foreach ($aliases as $alias => $facade)
        {
            if ( ! $this->isFacade($facade))
            {
                continue;
            }

            $data[] = $this->createRow($alias, $facade);
        }

        return $data;
    }

    /**
     * Create a row
     *
     * @param string $alias
     * @param string $facade
     * @return array
     */
    protected function createRow($alias, $facade)
    {
        return [
            $alias,
            $this->doResolve($facade),
            $this->getBinding($facade),
        ];
    }

    /**
     * Get all registered aliases
     *
     * @return array
     */
    protected function getAliases()
    {
        return AliasLoader::getInstance()->getAliases();
    }

    /**
     * Filter data by the query string
     *
     * @param array $aliases
     * @param string $query
     * @return array
     */
    protected function filter(array $aliases, $query)
    {
        $result = [];

        foreach ($aliases as $alias => $facade)
        {
            if ( ! Str::is(Str::studly($query), $alias))
            {
                continue;
            }

            $result[$alias] = $facade;
        }

        return $result;
    }

    /**
     * Determine whether the given class is a Facade
     *
     * @param string $class
     * @return bool
     */
    protected function isFacade($class)
    {
        if ( ! \class_exists($class))
        {
            return false;
        }

        return \is_subclass_of($class, 'Illuminate\Support\Facades\Facade');
    }

    /**
     * "Resolve" the facade
     *
     * @param string $facade
     * @return mixed
     */
    protected function doResolve($facade)
    {
        $instance = \call_user_func([$facade, 'getFacadeRoot']);

        return \get_class($instance);
    }

    /**
     * Get the IoC binding
     *
     * @param string $facade
     * @return string
     */
    protected function getBinding($facade)
    {
        $class = new \ReflectionClass(new $facade);

        $method = $class->getMethod('getFacadeAccessor');

        $method->setAccessible(true);

        $value = $method->invoke(null);

        // an object may be returned
        return \is_string($value) ? $value : '';
    }

}

