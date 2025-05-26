//For Testing purpose
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:ham/src/core/inyector_di/inyector.dart';
import 'package:ham/src/core/lifecycles/mortal.dart';

void main() {
  group('Inyector - Regular Dependency Tests', () {
    setUp(Inyector.reset);

    test('should add and retrieve a dependency', () {
      // Arrange
      const testValue = 'Test Value';

      // Act
      Inyector.add<String>(() => testValue);
      final result = Inyector.get<String>();

      // Assert
      expect(result, equals(testValue));
    });

    test('should add and retrieve a dependency with tag', () {
      // Arrange
      const tag1 = 'tag1';
      const tag2 = 'tag2';
      const value1 = 'Value 1';
      const value2 = 'Value 2';

      // Act
      Inyector.add<String>(() => value1, tag: tag1);
      Inyector.add<String>(() => value2, tag: tag2);

      // Assert
      expect(Inyector.get<String>(key: tag1), equals(value1));
      expect(Inyector.get<String>(key: tag2), equals(value2));
    });

    test('should remove a dependency', () {
      // Arrange
      Inyector.add<String>(() => 'Test');

      // Act
      Inyector.remove<String>();

      // Assert
      expect(() => Inyector.get<String>(), throwsA(anything));
    });

    test('should add a lazy dependency', () {
      // Arrange
      var constructorCalled = false;

      // Act
      Inyector.add<String>(() {
        constructorCalled = true;
        return 'Lazy Value';
      }, lazy: true);

      // Assert
      expect(constructorCalled, isFalse); // Constructor not called yet

      // Act - access the lazy dependency
      final result = Inyector.get<String>();

      // Assert
      expect(constructorCalled, isTrue); // Constructor called now
      expect(result, equals('Lazy Value'));
    });

    test('should clean all dependencies', () {
      // Arrange
      Inyector.add<String>(() => 'Test1');
      Inyector.add<int>(() => 42);

      // Act
      Inyector.clean();

      // Assert
      expect(() => Inyector.get<String>(), throwsA(anything));
      expect(() => Inyector.get<int>(), throwsA(anything));
    });

    test('should reset all dependencies', () {
      // Arrange
      Inyector.add<String>(() => 'Test1');
      Inyector.add<int>(() => 42);

      // Act
      Inyector.reset();

      // Assert
      expect(() => Inyector.get<String>(), throwsA(anything));
      expect(() => Inyector.get<int>(), throwsA(anything));
    });
  });

  group('Inyector - JSON Decoder Tests', () {
    setUp(Inyector.reset);
    

    test('should register and use a JSON decoder', () {
      // Arrange
      Inyector.registerJsonDecoder<TestModel>(TestModel.fromJson);
      final testJson = {'name': 'Test Name', 'value': 123};

      // Act
      final result = Inyector.decode<TestModel>(testJson);

      // Assert
      expect(result, isA<TestModel>());
      expect(result.name, equals('Test Name'));
      expect(result.value, equals(123));
    });

    test('should unregister a JSON decoder', () {
      // Arrange
      Inyector.registerJsonDecoder<TestModel>(TestModel.fromJson);

      // Act
      Inyector.unregisterJsonDecoder<TestModel>();

      // Assert - should throw InyectorKeyNotFound or any exception
      expect(
        () => Inyector.decode<TestModel>({'name': 'Test', 'value': 0}),
        throwsA(anything), // Acepta cualquier tipo de excepción
      );
    });

    test('should register multiple JSON decoders', () {
      // Arrange
      final decoders = {
        TestModel: TestModel.fromJson,
        AnotherModel: AnotherModel.fromJson,
      };

      // Act
      Inyector.registerJsonsDecoders(decoders);

      // Assert
      final model1 = Inyector.decode<TestModel>({'name': 'Test', 'value': 42});
      final model2 = Inyector.decode<AnotherModel>({'title': 'Another'});

      expect(model1.name, equals('Test'));
      expect(model2.title, equals('Another'));
    });
  });

  group('Inyector - Mortal Lifecycle Tests', () {
    setUp(Inyector.reset);

    test('should ensure onBirth is not called during reproduction lifecycle', () {
      // Arrange
      final parentService = TestMortalService();

      // Act - Add the parent service
      Inyector.add<TestMortalService>(() => parentService);

      // Assert - onBirth should be called when added the first time
      expect(
        parentService.birthCalled,
        isTrue,
        reason: 'onBirth should be called on initial add',
      );

      // Reset parent flags to track next operations
      parentService.resetFlags();

      // Act - Force reproduction
      Inyector.remove<TestMortalService>();

      // Get the child instance
      final childService = Inyector.get<TestMortalService>();

      // Assert - Verify child lifecycle
      expect(
        childService,
        isNot(same(parentService)),
        reason: 'Should be a new instance after reproduction',
      );
      expect(
        childService.childBirthCalled,
        isTrue,
        reason: 'onChildBirth should be called on child',
      );
      expect(
        childService.birthCalled,
        isFalse,
        reason: 'onBirth should NOT be called on reproduced child',
      );

      // Act - Remove child completely
      Inyector.reset();
      expect(
        () => Inyector.get<TestMortalService>(),
        throwsA(anything),
        reason: 'Should not exist after removal',
      );

      // Act - Add a new instance after complete removal
      final newInstance = TestMortalService();
      Inyector.add<TestMortalService>(() => newInstance);

      // Assert - onBirth should be called for fresh instances added to Inyector
      expect(
        newInstance.birthCalled,
        isTrue,
        reason: 'onBirth should be called when added after complete removal',
      );
    });

    test('should call onBirth when a mortal dependency is added', () {
      // Arrange
      final mortalService = TestMortalService();

      // Act
      Inyector.add<TestMortalService>(() => mortalService);

      // Assert
      expect(mortalService.birthCalled, isTrue);
    });

    test('should call onAsk when a mortal dependency is retrieved', () {
      // Arrange
      final mortalService = TestMortalService();
      Inyector.add<TestMortalService>(() => mortalService);
      mortalService.resetFlags(); // Reset to clearly see next calls

      // Act
      Inyector.get<TestMortalService>();

      // Assert
      expect(mortalService.askCalled, isTrue);
    });

    test(
      'should call onReproduce and onDie when a rebirth-enabled mortal is removed',
      () {
        // Arrange
        final mortalService = TestMortalService();
        Inyector.add<TestMortalService>(() => mortalService);
        mortalService.resetFlags(); // Reset to clearly see next calls

        // Act
        Inyector.remove<TestMortalService>();

        // Assert
        expect(mortalService.reproduceCalled, isTrue);
        expect(mortalService.dieCalled, isTrue);

        // The new instance should be in the inyector
        final newInstance = Inyector.get<TestMortalService>();
        expect(
          newInstance,
          isNot(same(mortalService)),
        ); // Should be a new instance
        expect(
          newInstance.childBirthCalled,
          isTrue,
        ); // onChildBirth should be called
      },
    );

    test(
      'should call onDieWithoutChildren when a non-rebirth mortal is removed',
      () {
        // Arrange
        final mortalService = TestMortalService();
        Inyector.add<TestMortalService>(() => mortalService, rebirth: false);
        mortalService.resetFlags(); // Reset to clearly see next calls

        // Act
        Inyector.remove<TestMortalService>();

        // Assert
        expect(mortalService.dieWithoutChildrenCalled, isTrue);
        expect(mortalService.reproduceCalled, isFalse); // Should not be called
      },
    );

    test(
      'should call onDie for all mortal dependencies during clean with rebirth',
      () {
        // Arrange
        final mortalService1 = TestMortalService();
        final mortalService2 = TestMortalService();

        Inyector.add<TestMortalService>(() => mortalService1, tag: 'service1');
        Inyector.add<TestMortalService>(() => mortalService2, tag: 'service2');

        mortalService1.resetFlags();
        mortalService2.resetFlags();

        // Act
        Inyector.clean();

        // Assert
        expect(mortalService1.reproduceCalled, isTrue);
        expect(mortalService1.dieCalled, isTrue);
        expect(mortalService2.reproduceCalled, isTrue);
        expect(mortalService2.dieCalled, isTrue);

        // New instances should be available
        final newInstance1 = Inyector.get<TestMortalService>(key: 'service1');
        final newInstance2 = Inyector.get<TestMortalService>(key: 'service2');

        expect(newInstance1, isNot(same(mortalService1)));
        expect(newInstance2, isNot(same(mortalService2)));
      },
    );

    test(
      'should call onDieWithoutChildren for mortal dependencies during clean without rebirth',
      () {
        // Arrange
        final mortalService = TestMortalService();
        Inyector.add<TestMortalService>(() => mortalService, rebirth: false);
        mortalService.resetFlags();

        // Act
        Inyector.clean();

        // Assert
        expect(mortalService.dieWithoutChildrenCalled, isTrue);
        expect(mortalService.reproduceCalled, isFalse);

        // Should not be available anymore
        expect(() => Inyector.get<TestMortalService>(), throwsA(anything));
      },
    );

    test(
      'should call onDieWithoutChildren for all mortal dependencies during reset',
      () {
        // Arrange
        final mortalService1 = TestMortalService();
        final mortalService2 = TestMortalService();

        Inyector.add<TestMortalService>(() => mortalService1, tag: 'service1');
        Inyector.add<TestMortalService>(() => mortalService2, tag: 'service2');

        mortalService1.resetFlags();
        mortalService2.resetFlags();

        // Act
        Inyector.reset();

        // Assert
        expect(mortalService1.dieWithoutChildrenCalled, isTrue);
        expect(mortalService2.dieWithoutChildrenCalled, isTrue);

        // Should not have called reproduce
        expect(mortalService1.reproduceCalled, isFalse);
        expect(mortalService2.reproduceCalled, isFalse);
      },
    );

    test('complete lifecycle test for Mortal dependencies', () {
      // This test verifies the full lifecycle of a Mortal object

      // Arrange - create mortal service
      final parentService = TestMortalService();

      // Act & Assert - Check onBirth when added
      Inyector.add<TestMortalService>(() => parentService);
      expect(
        parentService.birthCalled,
        isTrue,
        reason: 'onBirth should be called when added',
      );

      // Reset flags to track next operations
      parentService.resetFlags();

      // Act & Assert - Check onAsk when retrieved
      final retrievedService = Inyector.get<TestMortalService>();
      expect(
        retrievedService.askCalled,
        isTrue,
        reason: 'onAsk should be called when retrieved',
      );
      expect(
        retrievedService,
        same(parentService),
        reason: 'Should be the same instance',
      );

      parentService.resetFlags();

      // Act & Assert - Check reproduction cycle
      Inyector.remove<TestMortalService>();

      // Verify parent methods were called
      expect(
        parentService.reproduceCalled,
        isTrue,
        reason: 'onReproduce should be called',
      );
      expect(
        parentService.dieCalled,
        isTrue,
        reason: 'onDie should be called after reproduction',
      );

      // Get the child instance and verify it's different
      final childService = Inyector.get<TestMortalService>();
      expect(
        childService,
        isNot(same(parentService)),
        reason: 'Child should be a new instance',
      );
      expect(
        childService.childBirthCalled,
        isTrue,
        reason: 'onChildBirth should be called on child',
      );

      // Clean and verify final lifecycle
      childService.resetFlags();
      Inyector.reset();

      expect(
        childService.dieWithoutChildrenCalled,
        isTrue,
        reason: 'onDieWithoutChildren should be called during reset',
      );
    });
  });

  group('Inyector - Async Dependency Tests', () {
    setUp(Inyector.reset);

    test('should add and retrieve an async dependency', () async {
      // Arrange
      const expectedValue = 'Async Value';

      // Act
      await Inyector.addAsync<String>(() async {
        // Simulate async operation
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return expectedValue;
      });

      final result = Inyector.get<String>();

      // Assert
      expect(result, equals(expectedValue));
    });

    test('should add and retrieve an async mortal dependency', () async {
      // Arrange
      final mortalService = TestMortalService();

      // Act
      await Inyector.addAsync<TestMortalService>(() async {
        // Simulate async operation
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return mortalService;
      });

      // Assert
      expect(mortalService.birthCalled, isTrue);

      // Reset flags
      mortalService.resetFlags();

      // Get the service
      final result = Inyector.get<TestMortalService>();

      expect(result, same(mortalService));
      expect(mortalService.askCalled, isTrue);
    });
  });
}

// Test Models
class TestModel {
  TestModel(this.name, this.value);

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(json['name'] as String, json['value'] as int);
  }
  final String name;
  final int value;
}

class AnotherModel {
  AnotherModel(this.title);

  factory AnotherModel.fromJson(Map<String, dynamic> json) {
    return AnotherModel(json['title'] as String);
  }
  final String title;
}

// Test implementation of Mortal interface
class TestMortalService implements Mortal {
  bool birthCalled = false;
  bool askCalled = false;
  bool childBirthCalled = false;
  bool reproduceCalled = false;
  bool dieCalled = false;
  bool dieWithoutChildrenCalled = false;
  int birthCalledCount = 0;

  void resetFlags() {
    birthCalled = false;
    askCalled = false;
    childBirthCalled = false;
    reproduceCalled = false;
    dieCalled = false;
    dieWithoutChildrenCalled = false;
    // Intentionally not resetting birthCalledCount here
  }

  @override
  void onAsk() {
    askCalled = true;
  }

  @override
  void onBirth() {
    birthCalled = true;
    birthCalledCount++;
  }

  @override
  void onChildBirth() {
    childBirthCalled = true;
  }

  @override
  Mortal onReproduce() {
    reproduceCalled = true;
    return TestMortalService();
  }

  @override
  void onDie() {
    dieCalled = true;
  }

  @override
  void onDieWithoutChildren() {
    dieWithoutChildrenCalled = true;
  }
}
