# ezmaster-redis

ISTEX-compliant version of Redis for [ezmaster](https://github.com/Inist-CNRS/ezmaster)

## Parameters

EZmaster config file contains 2 parameters, for backup purpose :

```
{
  "DUMP_EACH_NBHOURS": 24,
  "DUMP_CLEANUP_MORE_THAN_NBDAYS": 30
}
```

Redis configuration is unchanged. To change it you can :

- set it dynamically using redis-cli
- edit config file from the container itself

A better solution should be found to be edit via ezmaster config file.
