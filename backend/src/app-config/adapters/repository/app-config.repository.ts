export abstract class AppConfigRepository {
  abstract findOrCreate(): Promise<string>;
}
