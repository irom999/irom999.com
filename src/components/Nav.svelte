<script lang="ts">
	import { resolve } from '$app/paths';
	import { page } from '$app/state';
	import * as DarkMode from 'svelte-fancy-darkmode';
	import MoonToSunny from '~icons/line-md/moon-filled-to-sunny-filled-loop-transition';
	import SunnyToMoon from '~icons/line-md/sunny-filled-loop-to-moon-filled-transition';
</script>

<header
	fcol
	fyc
	gap-y-lg
	grid
	grid-cols="1 md:2"
	mxa
	op="card hover:100"
	py-6
	text-xl
	transition-base
	view-transition--nav
>
	<div flex>
		<a
			aria-label="Home"
			font-bold
			href={resolve('/')}
			m="xa md:(b0 x0)"
			relative
		>
			<div
				style:view-transition-name="title-irom999"
				class={{ hidden: page.url.pathname === '/' }}
			>
				@irom999
			</div>
		</a>
	</div>
	<nav
		flex="wrap"
		font-bold
		fxc
		gap-4
		m="xa md:r0"
		md-fxe
		text-lg
	>
		<div flex gap="4 md:2" view-transition--nav-icons>
			<DarkMode.ToggleButton>
				{#snippet dark()}
					<SunnyToMoon />
				{/snippet}

				{#snippet light()}
					<MoonToSunny />
				{/snippet}
			</DarkMode.ToggleButton>
			<a
				class="i-teenyicons:github-solid"
				fyc
				href="https://github.com/irom999"
				mya
				target="_blank"
			>
				source code
			</a>
		</div>
	</nav>
</header>

<style>
a {
	--uno: no-underline;
}
</style>
