///CacheType enum.
///Defines the type of cache to be used.
enum CacheType {
  ///Hot cache, this enable the cache in memory.
  memory,

  ///Cold cache, this enable the cache in disk.
  disk,

  ///Enable both memory and disk cache.
  memoryAndDisk,
}
