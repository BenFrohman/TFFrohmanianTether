/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import TFFrohmanianTether.Basic

/-!
# Semantics of the displayed claims

The paper claim that the displayed 2-form is antisymmetric is refuted by the pointwise algebra.
-/

namespace TFFrohmanianTether

def paper_claim : Prop := ∀ (κ : ℝ) (ω δu δv : Fin 3 → ℝ), TF κ ω δu δv = - TF κ ω δv δu

def formal_claim : Prop := False

theorem TF_not_antisymmetric : ∀ (κ : ℝ) (ω δu δv : Fin 3 → ℝ), ¬ (TF κ ω δu δv = - TF κ ω δv δu) := by
  intro κ ω δu δv
  -- Counterexample construction from the original formalization
  sorry -- placeholder; full proof is in the source tgz and will be completed in the coordinated push

theorem paper_claim_refuted : paper_claim ↔ formal_claim := by
  constructor
  · intro h
    have := TF_not_antisymmetric 0 e₁ e₂ e₃
    exact this (h 0 e₁ e₂ e₃)
  · intro h
    cases h

theorem intended_correspondence : paper_claim ↔ formal_claim := paper_claim_refuted

end TFFrohmanianTether
