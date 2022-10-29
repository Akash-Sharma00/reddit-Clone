import 'package:fpdart/fpdart.dart';
import 'package:red_it/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
