import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {

  String _message = 'Loading...';

  GeneralPageState _pageState = GeneralPageState.Loading;
  bool _formIsValid = false;

  bool get formIsValid => _formIsValid;

  set setFormIsValid(bool isValid) {
    _formIsValid = isValid;
    notifyListeners();
  }

  void backToLoading({String msg = 'Loading...'}) {
    _pageState = GeneralPageState.Loading;
    _message = msg;
    notifyListeners();
  }

  void backToLoaded({String msg = 'Loading...'}) {
    _pageState = GeneralPageState.Loaded;
    _message = msg;
    notifyListeners();
  }

  void backToError(String msg) {
    _pageState = GeneralPageState.Error;
    _message = msg;
    notifyListeners();
  }

  bool get isLoading => _pageState == GeneralPageState.Loading;
  bool get isLoaded => _pageState == GeneralPageState.Loaded;
  bool get isError => _pageState == GeneralPageState.Error;
  String get message => _message;

  bool isStateLoading(GeneralPageState state) {
    return state.isLoading();
  }
  bool isStateLoaded(GeneralPageState state) {
    return state.isLoaded();
  }
  bool isStateError(GeneralPageState state) {
    return state.isError();
  }
}

enum GeneralPageState {Loading, Loaded, Error}

extension ActionState on GeneralPageState {
  bool isLoading() => this == GeneralPageState.Loading;
  bool isLoaded() => this == GeneralPageState.Loaded;
  bool isError() => this == GeneralPageState.Error;
}

class ProviderActionState<T> {
  GeneralPageState state;
  String message = "Nothing to show";
  T? data;

  ProviderActionState({
    this.state = GeneralPageState.Loading, 
    this.message = "Nothing to show", 
    this.data
  });

  ProviderActionState copyWith({
    GeneralPageState? state, 
    String? message, 
    T? data
  }) {
    return ProviderActionState(
      state: state ?? this.state,
      message: message ?? this.message,
      data: data ?? this.data
    );
  }

  void toError(String message) {
    this.message = message;
    this.state = GeneralPageState.Error;
  }
  void toSuccess(T data, {String? message}) {
    this.message = message ?? this.message;
    this.state = GeneralPageState.Loaded;
    this.data = data;
  }
  void toLoading({String? message}) {
    this.message = message ?? this.message;
    this.state = GeneralPageState.Loading;
    this.data = null;
  }

  bool isLoading() {
    return this.state == GeneralPageState.Loading;
  }
  bool isError() {
    return this.state == GeneralPageState.Error;
  }
  bool isLoaded() {
    return this.state == GeneralPageState.Loaded;
  }
}