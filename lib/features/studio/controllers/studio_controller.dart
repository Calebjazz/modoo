import 'package:flutter/foundation.dart';

import '../../outfits/models/outfit.dart';
import '../models/studio_garment.dart';

/// Shared Studio state so other screens (e.g. Looks) can load outfits into it.
class StudioController extends ChangeNotifier {
  static const defaultAvatar = 'AURA';
  static const minZoom = 70;
  static const maxZoom = 130;

  static final _defaultGarments = <StudioGarmentSlot, StudioGarment>{
    StudioGarmentSlot.outerwear: StudioPreviewCatalog.byId('leather-shacket')!,
    StudioGarmentSlot.top: StudioPreviewCatalog.byId('crop-knit')!,
    StudioGarmentSlot.bottom: StudioPreviewCatalog.byId('cargo-slacks')!,
  };

  String _avatarId = defaultAvatar;
  String _view = 'FRONT';
  int _zoomPercent = 100;
  StudioGarmentCategory _category = StudioGarmentCategory.tops;
  Map<StudioGarmentSlot, StudioGarment> _mounted = {..._defaultGarments};
  Map<StudioGarmentSlot, StudioGarment> _resetGarments = {..._defaultGarments};
  Outfit? _editing;
  int? _userId;

  String get avatarId => _avatarId;
  String get view => _view;
  int get zoomPercent => _zoomPercent;
  StudioGarmentCategory get category => _category;
  Map<StudioGarmentSlot, StudioGarment> get mountedGarments =>
      Map.unmodifiable(_mounted);

  /// Saved outfit currently open for editing, if any.
  Outfit? get editing => _editing;

  Map<StudioGarmentSlot, String> get mountedGarmentIds => {
    for (final entry in _mounted.entries) entry.key: entry.value.id,
  };

  void setAvatar(String avatarId) => _set(() => _avatarId = avatarId);

  void setView(String view) => _set(() => _view = view);

  void setCategory(StudioGarmentCategory category) =>
      _set(() => _category = category);

  void zoomIn() =>
      _set(() => _zoomPercent = (_zoomPercent + 10).clamp(minZoom, maxZoom));

  void zoomOut() =>
      _set(() => _zoomPercent = (_zoomPercent - 10).clamp(minZoom, maxZoom));

  void fit(StudioGarment garment) =>
      _set(() => _mounted = {..._mounted, garment.slot: garment});

  void remove(StudioGarmentSlot slot) =>
      _set(() => _mounted = Map.of(_mounted)..remove(slot));

  /// Restores the garments of the open outfit, or the studio default.
  void resetLook() => _set(() => _mounted = {..._resetGarments});

  /// Mounts [outfit]'s garments. With [useOutfitAvatar] the avatar switches
  /// too. With [edit] a saved outfit stays linked so saving updates it.
  void applyOutfit(
    Outfit outfit, {
    bool useOutfitAvatar = true,
    bool edit = false,
  }) {
    _set(() {
      if (useOutfitAvatar) _avatarId = outfit.avatarId;
      _mounted = {...outfit.garments};
      _resetGarments = {..._mounted};
      _editing = edit && !outfit.isCurated ? outfit : null;
    });
  }

  /// Links the studio to [outfit] after it was saved or updated.
  void markSaved(Outfit outfit) => _set(() {
    _editing = outfit;
    _resetGarments = {..._mounted};
  });

  /// Clears garments and any open outfit to start a new ensemble.
  void startNewEnsemble() => _set(() {
    _mounted = {};
    _resetGarments = {};
    _editing = null;
  });

  /// Unlinks a saved outfit that no longer exists.
  void forgetOutfit(int outfitId) {
    if (_editing?.id == outfitId) _set(() => _editing = null);
  }

  /// Clears the studio when a different user signs in or out.
  void bindUser(int? userId) {
    if (userId == _userId) return;
    _userId = userId;
    _avatarId = defaultAvatar;
    _view = 'FRONT';
    _zoomPercent = 100;
    _category = StudioGarmentCategory.tops;
    _mounted = {..._defaultGarments};
    _resetGarments = {..._defaultGarments};
    _editing = null;
    notifyListeners();
  }

  void _set(VoidCallback change) {
    change();
    notifyListeners();
  }
}
