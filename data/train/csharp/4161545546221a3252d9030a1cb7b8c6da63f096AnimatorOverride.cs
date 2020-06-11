using UnityEngine;

public class AnimatorOverride
{
    public static RuntimeAnimatorController GetEffectiveController(Animator animator)
    {
        RuntimeAnimatorController controller = animator.runtimeAnimatorController;

        AnimatorOverrideController overrideController = controller as AnimatorOverrideController;
        while (overrideController != null)
        {
            controller = overrideController.runtimeAnimatorController;
            overrideController = controller as AnimatorOverrideController;
        }

        return controller;
    }

    public static void OverrideAnimationClip(Animator anim, string name, AnimationClip clip)
    {
        AnimatorOverrideController overrideController = new AnimatorOverrideController();
        overrideController.runtimeAnimatorController = GetEffectiveController(anim);
        overrideController[name] = clip;
        anim.runtimeAnimatorController = overrideController;
    }
}
