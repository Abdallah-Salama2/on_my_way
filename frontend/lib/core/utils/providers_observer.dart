import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProvidersObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    // Log or handle changes
    log('Provider ${provider.name ?? provider.runtimeType} updated:');
    // log('-- Previous value: $previousValue');
    log('++ New value: $newValue');
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    super.didAddProvider(provider, value, container);
    // Handle provider addition
    log('==>> Provider ${provider.name ?? provider.runtimeType} created. Value: ${value?? value}');
    
  }

  // @override
  // void didDisposeProvider(
  //   ProviderBase provider,
  //   ProviderContainer container,
  // ) {
  //   super.didDisposeProvider(provider, container);
  //   // Handle provider disposal
  //   log('=====>> Provider ${provider.name ?? provider.runtimeType} disposed.');
  // }
}