package org.gbif.ecat.voc;

public enum NameType {
  sciname, // a scientific name which is not well formed
  wellformed, // a well formed scientific name according to present nomenclatural rules. This is either the canonical or
  // canonical with authorship
  doubtful, // doubtful whether this is a scientific name at all
  blacklisted, // surely not a scientific name
  virus, // a virus name
  hybrid, // a hybrid *formula* (not a hybrid name)
  informal, // a scientific name with some informal addition like "cf." or indetermined like Abies spec.
  cultivar; // a cultivated plant name

  public static NameType fromString(String x) {
    if (x == null) {
      return null;
    }
    x = x.toLowerCase().trim();
    if (x.length() == 0) {
      return null;
    }
    for (NameType term : NameType.values()) {
      if (term.toString().toLowerCase().equals(x)) {
        return term;
      }
      if (term.toString().toLowerCase().charAt(0) == x.charAt(0)) {
        return term;
      }
    }
    return null;
  }

  public static NameType valueOf(Integer id) {
    if (id == null) {
      return null;
    }
    for (NameType term : NameType.values()) {
      if (term.ordinal() == id) {
        return term;
      }
    }
    return null;
  }

  /**
   * @return true if this name type is "better", ie more correct than the given name
   */
  public boolean isBetterThan(NameType other) {
    if (other == null) {
      return true;
    }
    if (NameType.blacklisted != this) {
      if (NameType.informal == this && (NameType.blacklisted == other)) {
        return true;
      } else if (NameType.doubtful == this && (NameType.blacklisted == other || NameType.informal == other)) {
        return true;
      } else if ((NameType.sciname == this || NameType.virus == this || NameType.hybrid == this) && (
        NameType.blacklisted == other || NameType.informal == other || NameType.doubtful == other)) {
        return true;
      } else if (NameType.wellformed == this && (NameType.wellformed != other)) {
        return true;
      }
    }
    return false;
  }

  public boolean isParsable() {
    return !(NameType.hybrid == this || NameType.virus == this || NameType.blacklisted == this);
  }

}
