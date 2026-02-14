<script lang="ts">
	type Props = {
		title: string;
		viewTransitionName?: string;
		selectDisabled?: boolean;
		opacity?: boolean;
	};
	const {
		title,
		viewTransitionName,
		selectDisabled = false,
		opacity = true,
	}: Props = $props();
</script>

<h1
	style:view-transition-name={viewTransitionName}
	class={{ 'op-35 dark:op-20': opacity, 'select-none': selectDisabled }}
	font="mono bold"
	line-height-none
	my-8
	text="transparent"
	class:f-text-32-64={true}
	style="font-size: clamp(2rem, 5vw, 4rem); -webkit-text-stroke: 1.5px #aaa; text-stroke: 1.5px #aaa;"
>
	{title}
</h1>
