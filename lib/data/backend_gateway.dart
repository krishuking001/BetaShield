import '../features/family/domain/family_models.dart';
import '../features/pairing/domain/pairing_models.dart';

/// Everything the app needs from a backend. Implemented by the Cloud
/// Functions client and by the in-memory demo backend.
abstract interface class BackendGateway
    implements
        PairingRepository,
        EventUplinkRepository,
        FamilyRepository,
        ScamListRepository {}
