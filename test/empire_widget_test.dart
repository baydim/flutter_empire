import 'package:empire/empire_property.dart';
import 'package:empire/empire_widget.dart';
import 'package:empire/empire_state.dart';
import 'package:empire/empire_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

class _ApplicationViewModel extends EmpireViewModel {
  late EmpireProperty<bool> changed;

  @override
  void initProperties() {
    changed = createProperty(false, propertyName: 'changed');
  }

  void change() => changed(!changed.value);
}

class _ApplicationSubViewModel extends EmpireViewModel {
  late final EmpireStringProperty viewModelName;
  @override
  void initProperties() {
    viewModelName = createStringProperty('SubViewModel');
  }
}

class _TestViewModel extends EmpireViewModel {
  late EmpireProperty<String?> firstName;
  late EmpireProperty<String?> lastName;
  late EmpireProperty<int> age;

  @override
  void initProperties() {
    firstName = createNullProperty();
    lastName = createNullProperty();
    age = createProperty(1);
  }
}

class _MyWidget extends EmpireWidget<_TestViewModel> {
  final _ApplicationViewModel applicationViewModel;
  final _ApplicationSubViewModel appSubViewModel;
  const _MyWidget({
    Key? key,
    required _TestViewModel viewModel,
    required this.applicationViewModel,
    required this.appSubViewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, _TestViewModel> createEmpire() {
    return _MyWidgetState(viewModel);
  }
}

class _MyWidgetState extends EmpireState<_MyWidget, _TestViewModel> {
  _MyWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Empire<_ApplicationViewModel>(
      widget.applicationViewModel,
      onAppStateChanged: () => math.Random().nextInt(1000000).toString(),
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (outerContext) {
              return Empire(
                widget.appSubViewModel,
                onAppStateChanged: () =>
                    math.Random().nextInt(1000000).toString(),
                child: Builder(builder: (innerContext) {
                  return Center(
                    child: Column(
                      children: [
                        Text(viewModel.firstName.value ?? ''),
                        Text(viewModel.lastName.value ?? ''),
                        Text(
                          viewModel.age.value.toString(),
                        ),
                        Text(
                            '${Empire.of<_ApplicationViewModel>(outerContext).viewModel().changed}'),
                        Text(
                            '${Empire.of<_ApplicationSubViewModel>(innerContext).viewModel().viewModelName}')
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  late _MyWidget mainWidget;
  late _TestViewModel viewModel;
  late _ApplicationViewModel appViewModel;
  late _ApplicationSubViewModel subViewModel;
  setUp(() {
    viewModel = _TestViewModel();
    appViewModel = _ApplicationViewModel();
    subViewModel = _ApplicationSubViewModel();
    mainWidget = _MyWidget(
      viewModel: viewModel,
      applicationViewModel: appViewModel,
      appSubViewModel: subViewModel,
    );
  });

  testWidgets(
      'EmpireWidget Test - Finds Correct Text Widget After Property Change',
      (tester) async {
    viewModel.firstName("John");
    await tester.pumpWidget(mainWidget);

    expect(find.text("John"), findsOneWidget);

    viewModel.firstName("Bob");
    await tester.pumpAndSettle();

    expect(find.text("Bob"), findsOneWidget);
  });

  testWidgets('Empire App State Test - Widgets Update on App View Model Change',
      (tester) async {
    await tester.pumpWidget(mainWidget);

    final text = find.text("false");
    expect(text, findsOneWidget);

    appViewModel.change();

    await tester.pumpAndSettle();

    final textTwo = find.text("true");
    expect(textTwo, findsOneWidget);
  });

  testWidgets('Update More Than One Property - All Widgets Update',
      (tester) async {
    const initialFirstName = 'John';
    const initialLastName = 'Smith';
    const initialAge = 88;

    viewModel.firstName(initialFirstName);
    viewModel.lastName(initialLastName);
    viewModel.age(initialAge);

    await tester.pumpWidget(mainWidget);

    expect(find.text(initialFirstName), findsOneWidget);
    expect(find.text(initialLastName), findsOneWidget);
    expect(find.text(initialAge.toString()), findsOneWidget);

    const newFirstName = 'Bob';
    const newLastName = 'Brown';
    const newAge = 20;

    viewModel.setMultiple([
      {viewModel.firstName: newFirstName},
      {viewModel.lastName: newLastName},
      {viewModel.age: newAge},
    ]);

    await tester.pumpAndSettle();

    expect(find.text(newFirstName), findsOneWidget);
    expect(find.text(newLastName), findsOneWidget);
    expect(find.text(newAge.toString()), findsOneWidget);
  });

  testWidgets(
      'Update More Than One Property Starting from Null Keys - All Widgets Update',
      (tester) async {
    await tester.pumpWidget(mainWidget);

    const newFirstName = 'Bob';
    const newLastName = 'Brown';
    const newAge = 20;

    viewModel.setMultiple([
      {viewModel.firstName: newFirstName},
      {viewModel.lastName: newLastName},
      {viewModel.age: newAge},
    ]);

    await tester.pumpAndSettle();

    expect(find.text(newFirstName), findsOneWidget);
    expect(find.text(newLastName), findsOneWidget);
    expect(find.text(newAge.toString()), findsOneWidget);
  });

  testWidgets('EmpireWidget Test - Finds Sub Application View Model',
      (tester) async {
    await tester.pumpWidget(mainWidget);

    expect(find.text(subViewModel.viewModelName.value), findsOneWidget);
  });

  testWidgets('EmpireWidget Test - Finds Sub Application View Model',
      (tester) async {
    await tester.pumpWidget(mainWidget);

    expect(find.text(subViewModel.viewModelName.value), findsOneWidget);
  });
}
