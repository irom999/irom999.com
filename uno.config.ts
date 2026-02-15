import type { PresetUnoTheme } from 'unocss';
import {
	defineConfig,
	presetAttributify,
	presetIcons,
	presetTypography,
	presetWebFonts,
	presetWind3,
	transformerDirectives,
	transformerVariantGroup,
} from 'unocss';
import { presetFluid } from 'unocss-preset-fluid';

const theme = {
	colors: {
		accent: {
			100: '#6B8AFF',
			200: '#4D6BDD',
			300: '#1A3A8F',
		},
		text: {
			100: '#FFFFFF',
			150: '#fafafa',
			200: '#e0e0e0',
			300: '#b3b3b3',
			400: '#808080',
			500: '#4d4d4d',
			600: '#262626',
			700: '#1a1a1a',
			800: '#0f0f0f',
		},
		bg: {
			base: '#0F0F0F',
			100: '#1E1E1E',
			200: '#2d2d2d',
			300: '#454545',
		},
	},
} as const satisfies PresetUnoTheme;

export default defineConfig({
	presets: [
		presetWind3(),
		presetAttributify(),
		presetIcons(),
		presetWebFonts({
			provider: 'bunny',
			fonts: {
				sans: 'Inter:400,600,800',
				mono: 'DM Mono:400,600',
				code: ['JetBrains Mono', 'Fira Code', 'monospace'],
			},
			timeouts: {
				warning: 5000,
				failure: 60000,
			},
		}),
		presetTypography({
			cssExtend: {
				code: {
					color: theme.colors.text[800],
				},
				'html.dark code': {
					color: theme.colors.text[100],
				},
			},
		}),
		presetFluid(),
	],
	transformers: [transformerDirectives(), transformerVariantGroup()],
	content: {
		pipeline: {
			exclude: [/~icons/, /svelte-meta-tags/],
		},
	},
	extendTheme: (_theme) => {
		const merged = { ..._theme };
		if (merged.colors && typeof merged.colors === 'object') {
			Object.assign(merged.colors, theme.colors);
		}
		return merged;
	},
	shortcuts: [
		{
			'blog-list-icon': 'shrink-0 size-5',
			'border-base': 'border-[#8884]',
			'op-card': 'op70 dark:op50 hover:op80 group-hover:op80',
			'transition-base': 'transition-all transition-duration-500',
			fcc: 'flex justify-center items-center',
			fcol: 'flex flex-col',
			fxc: 'flex justify-center',
			fxe: 'flex justify-end',
			fyc: 'flex items-center',
			fys: 'flex items-start',
			gcc: 'grid place-content-center place-items-center',
		},
		[
			/^btn-(\w+)$/,
			([_, color]: string[]) =>
				`op50 px2.5 py1 transition-all duration-200 ease-out no-underline! hover:(op100 text-${color} bg-${color}/10) border border-base! rounded`,
		],
	],
});
