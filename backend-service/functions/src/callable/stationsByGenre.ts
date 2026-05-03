import { HttpsError, onCall } from "firebase-functions/v2/https";
import { requireAuth } from "../lib/auth";
import { cacheKey, withCache } from "../lib/cache";
import { asObject, optionalInt, optionalString } from "../lib/input";
import { normalizePage } from "../lib/normalize";
import { RAPIDAPI_KEY, rapidApiGet } from "../lib/rapidapi";
import type { Page, Station } from "../lib/types";

const TTL_SECONDS = 60 * 60; // 1h

export const stationsByGenre = onCall(
  { secrets: [RAPIDAPI_KEY] },
  async (request) => {
    requireAuth(request);
    const d = asObject(request.data);
    const genreId = optionalInt(d.genreId, "genreId", 1, Number.MAX_SAFE_INTEGER);
    const genreSlug = optionalString(d.genreSlug, "genreSlug");
    if (genreId === undefined && !genreSlug) {
      throw new HttpsError("invalid-argument", "Provide genreId or genreSlug.");
    }
    const page = optionalInt(d.page, "page", 1, 1000) ?? 1;
    const limit = optionalInt(d.limit, "limit", 1, 100) ?? 20;

    const path = genreSlug
      ? `/genres/slug/${encodeURIComponent(genreSlug)}/radios`
      : `/genres/${genreId}/radios`;

    const key = cacheKey("stationsByGenre", { genreId, genreSlug, page, limit });
    return withCache<Page<Station>>(key, TTL_SECONDS, async () => {
      const raw = await rapidApiGet(path, { page, limit });
      return normalizePage(raw, page, limit);
    });
  },
);
