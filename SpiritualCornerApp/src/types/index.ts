/**
 * Global type definitions for Spiritual Corner App
 */

// Re-export all types from this folder
export * from './prayer';

// Common types used across the app
export interface BaseEntity {
  id: string;
  createdAt?: string;
  updatedAt?: string;
}
