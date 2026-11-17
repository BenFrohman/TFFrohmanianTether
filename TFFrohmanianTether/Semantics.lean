/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import TFFrohmanianTether.Basic

namespace TFFrohmanianTether

def paper_claim : Prop :=
  ∀ (κ : ℝ) (ω δu δv : Fin 3 → ℝ),
    TF κ ω δu δv = - TF κ ω δv δu

def formal_claim : Prop := False

theorem intended_correspondence : formal_claim ↔ paper_claim := by
  constructor
  · intro h; exact h.elim
  · intro h
    exact (TF_not_antisymmetric h).elim

theorem paper_claim_refuted : ¬ paper_claim :=
  TF_not_antisymmetric

end TFFrohmanianTether
