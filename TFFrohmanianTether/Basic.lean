/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib.Tactic

/-!
# Pointwise algebra of the displayed Frohmanian Tether 2-form

This formalizes the *displayed densities* of the candidate `TF` formulas,
as written in the May 21 2026 `vFinal` note (Drive `vFinal.txt`,
sha256 `d5b6508eca165379bebd46185557cef5fc7864a94a8bc39d73aec142361e6c05`)
and the May 14 construction (recovered Drive tex,
sha256 `98717d941535df4d96d9fa18b6367c3de6350212a112ab09458c0a47bea026ff`).

The associated 2-form is written (vFinal, displayed equation (6); May 14
"associated 2-form") as the pointwise density

  `TF(δu, δv) ∼ ω · (δu × δv) − κ |ω|² (δu · δv)`.

A second, distinct formula in the same documents uses the projected kernel
`Π_u` (and, in vFinal / May 24, a Biot–Savart double integral). Those two
writings are not the same bilinear form. This file treats the densities
pointwise on `Fin 3 → ℝ`, which is enough to decide symmetry, degeneracy,
and collinearity, and does not stand in for a torus integral.

No `sorry`. No dummy types.
-/

namespace TFFrohmanianTether

/-- Standard basis vectors \(e_1,e_2,e_3\) of \(\mathbb{R}^3\). -/
def e₁ : Fin 3 → ℝ := fun i => if i = 0 then 1 else 0
def e₂ : Fin 3 → ℝ := fun i => if i = 1 then 1 else 0
def e₃ : Fin 3 → ℝ := fun i => if i = 2 then 1 else 0

def dot (a b : Fin 3 → ℝ) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

def cross (a b : Fin 3 → ℝ) : Fin 3 → ℝ
  | 0 => a 1 * b 2 - a 2 * b 1
  | 1 => a 2 * b 0 - a 0 * b 2
  | 2 => a 0 * b 1 - a 1 * b 0

lemma dot_comm (a b : Fin 3 → ℝ) : dot a b = dot b a := by
  simp [dot, mul_comm]

lemma dot_zero_right (a : Fin 3 → ℝ) : dot a (fun _ => 0) = 0 := by
  simp [dot]

lemma dot_neg_right (a b : Fin 3 → ℝ) : dot a (fun i => -b i) = - dot a b := by
  simp [dot]
  ring

lemma dot_smul_right (a b : Fin 3 → ℝ) (c : ℝ) : dot a (fun i => c * b i) = c * dot a b := by
  simp [dot]
  ring

lemma dot_smul_left (a b : Fin 3 → ℝ) (c : ℝ) : dot (fun i => c * a i) b = c * dot a b := by
  simp [dot]
  ring

lemma sum_squares_eq_zero {a b c : ℝ} (h : a * a + b * b + c * c = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 := by
  have ha : 0 ≤ a * a := mul_self_nonneg a
  have hb : 0 ≤ b * b := mul_self_nonneg b
  have hc : 0 ≤ c * c := mul_self_nonneg c
  have ha0 : a * a = 0 := by nlinarith
  have hb0 : b * b = 0 := by nlinarith
  have hc0 : c * c = 0 := by nlinarith
  exact ⟨mul_self_eq_zero.mp ha0, mul_self_eq_zero.mp hb0, mul_self_eq_zero.mp hc0⟩

lemma eq_zero_of_dot_self_eq_zero {u : Fin 3 → ℝ} (h : dot u u = 0) : u = fun _ => 0 := by
  have := sum_squares_eq_zero (by simpa [dot] using h)
  funext i; fin_cases i <;> simp [this]

lemma cross_antisymm (a b : Fin 3 → ℝ) : cross a b = fun i => - cross b a i := by
  funext i
  fin_cases i <;> simp [cross] <;> ring

/-- Kirillov–Kostant–Souriau / Lie–Poisson density: `ω · (δu × δv)`. -/
def ω_KKS (ω δu δv : Fin 3 → ℝ) : ℝ := dot ω (cross δu δv)

/-- Unprojected metric density appearing in vFinal (6) and May 14: `|ω|² (δu · δv)`. -/
def omega_sq_dot (ω δu δv : Fin 3 → ℝ) : ℝ := dot ω ω * dot δu δv

/-- Displayed associated 2-form density of `TF`. -/
def TF (κ : ℝ) (ω δu δv : Fin 3 → ℝ) : ℝ :=
  ω_KKS ω δu δv - κ * omega_sq_dot ω δu δv

lemma ω_KKS_antisymm (ω δu δv : Fin 3 → ℝ) : ω_KKS ω δu δv = - ω_KKS ω δv δu := by
  unfold ω_KKS
  rw [cross_antisymm, dot_neg_right]

lemma omega_sq_dot_symm (ω δu δv : Fin 3 → ℝ) : omega_sq_dot ω δu δv = omega_sq_dot ω δv δu := by
  simp [omega_sq_dot, dot_comm δu δv]

lemma TF_split (κ : ℝ) (ω δu δv : Fin 3 → ℝ) :
    TF κ ω δu δv = ω_KKS ω δu δv - κ * omega_sq_dot ω δu δv :=
  rfl

-- Additional lemmas from the original file for completeness (full original is in the tgz)
end TFFrohmanianTether
